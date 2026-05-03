

import 'package:flutter/material.dart';
import 'src/config.dart';
import 'src/update_logic.dart';
import 'src/update_bottom_sheet.dart';

export 'src/config.dart';

/// A class that provides the ability to check for updates and display a bottom sheet
class UpdateCheckerBottomSheet {
  /// Checks for an update based on the provided [config] and displays the bottom sheet if an update is available.
  /// Returns true if an update was found and the bottom sheet was shown, false otherwise.
  static Future<bool> checkAndUpdate(
    BuildContext context, {
    required UpdateCheckerConfig config,
  }) async {
    final updateLogic = UpdateLogic(config);
    final updateData = await updateLogic.checkUpdateAvailable();

    if (updateData != null && context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => UpdateBottomSheet(
          config: config,
          latestVersion: updateData['version'],
          downloadUrl: updateData['url'],
          releaseNotes: updateData['notes'],
        ),
      );
      return true;
    }

    return false;
  }
}
