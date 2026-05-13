import 'dart:io';

import 'package:flutter/material.dart';
import 'src/utils.dart';
import 'src/config.dart';
import 'src/update_logic.dart';
import 'src/update_bottom_sheet.dart';

export 'src/config.dart';

/// The main entry point for the Update Checker Bottom Sheet package.
///
/// This class provides a simple static method to check for app updates
/// hosted on GitHub Releases and display a premium bottom sheet interface.
class UpdateCheckerBottomSheet {
  /// Orchestrates the update check process and displays the UI if needed.
  ///
  /// [context] is the build context required to show the modal bottom sheet.
  /// [config] contains all settings including the target GitHub repository and UI customization.
  /// [showIfUpToDate] determines if the bottom sheet should be shown even
  /// when the app is already on the latest version (useful for manual update checks).
  ///
  /// Returns `true` if the bottom sheet was actually displayed, and `false`
  /// if the check was skipped, failed, or if no update was found and [showIfUpToDate] is false.
  ///
  /// **Note**: This method returns immediately if called on platforms other
  /// than Android, as OTA updates are currently only supported for Android.
  static Future<bool> checkAndUpdate(
    BuildContext context, {
    required UpdateCheckerConfig config,
    bool showIfUpToDate = true,
  }) async {
    // This package only supports Android
    if (!Platform.isAndroid) return false;

    final updateLogic = UpdateLogic(config);

    // Clean up any old APK files from previous runs to save space
    await updateLogic.cleanupUpdateFiles();

    // Check for internet connectivity first
    final bool hasInternet = await UpdateUtils.hasInternet();
    if (!hasInternet) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => UpdateBottomSheet(
            config: config,
            latestVersion: "",
            releaseNotes: "",
            showNetworkError: true,
          ),
        );
        return true;
      }
      return false;
    }

    final updateData = await updateLogic.checkLatestVersionInfo();

    if (updateData == null) return false;

    final bool isUpdateAvailable = updateData['isUpdateAvailable'] ?? false;

    if (isUpdateAvailable || showIfUpToDate) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => UpdateBottomSheet(
            config: config,
            latestVersion: updateData['latestVersion'],
            downloadUrl: updateData['url'],
            releaseNotes: updateData['notes'],
            isUpToDate: !isUpdateAvailable,
          ),
        );
        return true;
      }
    }

    return false;
  }
}
