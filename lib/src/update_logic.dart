import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'utils.dart';

/// Orchestrates the logic for checking updates and triggering the OTA installation.
class UpdateLogic {
  /// The GitHub repository to check for releases.
  final String githubRepo;

  /// The Android Provider Authority used by ota_update.
  final String? androidProviderAuthority;

  /// Base URL for the GitHub API.
  static const String githubApiBase = "https://api.github.com/repos";

  /// The default suffix for the FileProvider authority.
  static const String defaultProviderSuffix =
      ".update_checker_bottom_sheet.provider";

  /// Initializes the update logic with the given repository and authority.
  UpdateLogic({
    required this.githubRepo,
    this.androidProviderAuthority,
  });

  /// Fetches the latest release data from the GitHub API.
  ///
  /// Returns a JSON map of the release info, or null if the request fails.
  Future<Map<String, dynamic>?> getLatestGitHubRelease() async {
    try {
      final response = await http.get(
        Uri.parse("$githubApiBase/$githubRepo/releases/latest"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Returns the correct APK download URL for the device's CPU architecture.
  ///
  /// It performs a tiered search:
  /// 1. Exact architecture match (e.g., 'arm64-v8a').
  /// 2. 'universal' or 'release' keywords.
  /// 3. First available APK asset.
  String? getDownloadUrlForDevice(Map<String, dynamic> release) {
    final assets = release['assets'] as List<dynamic>?;
    if (assets == null || assets.isEmpty) return null;

    final arch = UpdateUtils.getDeviceArch();
    final List<String> apkUrls = [];

    // 1. Try to find an arch-specific APK
    for (final asset in assets) {
      final name = (asset['name'] as String?)?.toLowerCase() ?? '';
      if (name.endsWith('.apk')) {
        if (name.contains(arch)) {
          return asset['browser_download_url'] as String?;
        }
        apkUrls.add(asset['browser_download_url'] as String);
      }
    }

    // 2. Fallback: Look for 'universal' or 'release' in the name
    for (final url in apkUrls) {
      final lowerUrl = url.toLowerCase();
      if (lowerUrl.contains('universal') || lowerUrl.contains('release')) {
        return url;
      }
    }

    // 3. Last resort: return the first .apk found
    return apkUrls.isNotEmpty ? apkUrls.first : null;
  }

  /// Triggers an OTA update using the provided [url].
  ///
  /// Automatically resolves the correct FileProvider authority.
  Stream<OtaEvent> startOtaUpdate(String url) {
    return Stream.fromFuture(PackageInfo.fromPlatform()).asyncExpand((info) {
      final authority =
          androidProviderAuthority ??
          "${info.packageName}$defaultProviderSuffix";
      return OtaUpdate().execute(url, androidProviderAuthority: authority);
    });
  }

  /// High-level check for updates.
  ///
  /// Returns update info if a newer version exists, otherwise null.
  Future<Map<String, dynamic>?> checkUpdateAvailable() async {
    final info = await checkLatestVersionInfo();
    if (info != null && info['isUpdateAvailable'] == true) {
      return info;
    }
    return null;
  }

  /// Checks for the latest version info regardless of whether an update is available.
  ///
  /// Returns a map containing status flags, version numbers, and release notes.
  Future<Map<String, dynamic>?> checkLatestVersionInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final release = await getLatestGitHubRelease();
      if (release == null) return null;

      final String latestVerWithTag = release['tag_name'].toString();
      final bool isUpdateAvailable = UpdateUtils.isNewerVersion(
        latestVerWithTag,
        info.version,
        info.buildNumber,
      );

      return {
        'isUpdateAvailable': isUpdateAvailable,
        'latestVersion': latestVerWithTag.startsWith('v')
            ? latestVerWithTag.substring(1)
            : latestVerWithTag,
        'currentVersion': info.version,
        'url': getDownloadUrlForDevice(release),
        'notes': release['body'] ?? "No release notes available.",
      };
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  /// Deletes any lingering .apk files in the app's download directory to save space.
  ///
  /// This helps prevent storage bloat from repeated failed downloads.
  Future<void> cleanupUpdateFiles() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null && await directory.exists()) {
        final List<FileSystemEntity> files = directory.listSync();
        for (final file in files) {
          if (file is File && file.path.toLowerCase().endsWith('.apk')) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      // Silent fail: ignore cleanup errors
    }
  }
}
