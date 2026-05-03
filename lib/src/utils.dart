import 'dart:io';

class UpdateUtils {
  /// Compares semantic versions.
  /// Returns true if [latest] is newer than [current] with [buildNumber].
  static bool isNewerVersion(
    String latest,
    String current,
    String buildNumber,
  ) {
    try {
      // Remove any 'v' prefix
      final latestClean = latest.startsWith('v') ? latest.substring(1) : latest;

      // Split into version and build number
      final latestParts = latestClean
          .split('+')[0]
          .split('.')
          .map(int.parse)
          .toList();
      final latestBuild = latestClean.contains('+')
          ? int.parse(latestClean.split('+')[1])
          : 0;

      final currentParts = current.split('.').map(int.parse).toList();
      final currentBuild = int.tryParse(buildNumber) ?? 0;

      // Pad parts to equal length for comparison
      final maxLength = latestParts.length > currentParts.length
          ? latestParts.length
          : currentParts.length;

      for (int i = 0; i < maxLength; i++) {
        final l = i < latestParts.length ? latestParts[i] : 0;
        final c = i < currentParts.length ? currentParts[i] : 0;

        if (l > c) return true;
        if (l < c) return false;
      }

      // If version numbers are equal, compare build numbers
      return latestBuild > currentBuild;
    } catch (e) {
      return false;
    }
  }

  /// Detects the device CPU architecture and maps it to standard APK ABI names.
  static String getDeviceArch() {
    final machine = _getMachineArch();

    if (machine.contains('aarch64') || machine.contains('arm64')) {
      return 'arm64-v8a';
    } else if (machine.contains('arm')) {
      return 'armeabi-v7a';
    } else if (machine.contains('x86_64') || machine.contains('amd64')) {
      return 'x86_64';
    }

    return 'arm64-v8a';
  }

  static String _getMachineArch() {
    try {
      if (Platform.isAndroid) {
        final result = Process.runSync('uname', ['-m']);
        return (result.stdout as String).trim().toLowerCase();
      }
    } catch (_) {}
    return 'aarch64';
  }
}
