

import 'dart:io';

import 'package:flutter/material.dart';
import 'src/config.dart';
import 'src/update_logic.dart';
import 'src/update_bottom_sheet.dart';

export 'src/config.dart';

/// A class that provides the ability to check for updates and display a bottom sheet
class UpdateCheckerBottomSheet {
  /// Checks for an update based on the provided [config] and displays the bottom sheet if an update is available.
  /// If [showIfUpToDate] is true, it also shows the bottom sheet if the app is already on the latest version.
  /// Returns true if the bottom sheet was shown, false otherwise.
  static Future<bool> checkAndUpdate(
    BuildContext context, {
    required UpdateCheckerConfig config,
    bool showIfUpToDate = false,
  }) async {
    // This package only supports Android
    if (!Platform.isAndroid) return false;

    final updateLogic = UpdateLogic(config);
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
