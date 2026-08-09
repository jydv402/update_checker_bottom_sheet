import 'dart:io';

import 'package:flutter/material.dart';
import 'src/utils.dart';
import 'src/theme.dart';
import 'src/update_logic.dart';
import 'src/update_bottom_sheet.dart';

export 'src/theme.dart';

/// Presentation styles supported by the update checker.
enum UpdateCheckerStyle {
  /// Shows the update UI as a bottom sheet.
  bottomSheet,

  /// Shows the update UI as an alert dialog.
  alertDialog,
}

/// The main entry point for the Update Checker package.
///
/// This provides a singular static method [UpdateChecker.check] to trigger an update check:
/// - Inside `initState` on launch (e.g. using a post-frame callback).
/// - Inside a button press callback for manual checks.
class UpdateChecker {
  // Static constructor to prevent instantiation.
  const UpdateChecker._();

  /// Global theme configuration for all update check sheets.
  static UpdateCheckerThemeData? theme;

  static Widget _buildUpdateDialog({
    required String githubRepo,
    required String? androidProviderAuthority,
    required UpdateCheckerThemeData themeData,
    required String latestVersion,
    required String? downloadUrl,
    required String releaseNotes,
    required bool isUpToDate,
    required bool showNetworkError,
    required bool enableHaptics,
    required bool showRedirectButton,
  }) {
    final dialogTheme = themeData.mergeWith(
      const UpdateCheckerThemeData(
        showHandle: false,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        borderRadius: 24,
      ),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: UpdateBottomSheet(
        githubRepo: githubRepo,
        androidProviderAuthority: androidProviderAuthority,
        themeData: dialogTheme,
        latestVersion: latestVersion,
        downloadUrl: downloadUrl,
        releaseNotes: releaseNotes,
        isUpToDate: isUpToDate,
        showNetworkError: showNetworkError,
        isDialogStyle: true,
        enableHaptics: enableHaptics,
        showRedirectButton: showRedirectButton,
      ),
    );
  }

  /// Checks for updates and triggers the update UI if needed.
  ///
  /// returns `true` if the update UI was displayed, and `false` otherwise.
  static Future<bool> check(
    BuildContext context, {
    required String githubRepo,
    UpdateCheckerStyle style = UpdateCheckerStyle.bottomSheet,
    bool showIfUpToDate = true,
    bool enableHaptics = false,
    bool showRedirectButton = false,
    String? androidProviderAuthority,
    Color? backgroundColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? accentColor,
    Color? accentTextColor,
    Color? pillColor,
    Color? boxColor,
    Color? handleColor,
    Color? borderColor,
    IconData? updateIcon,
    IconData? upToDateIcon,
    IconData? noInternetIcon,
    double? borderRadius,
    EdgeInsets? padding,
    double? buttonBorderRadius,
    TextStyle? titleStyle,
    TextStyle? versionStyle,
    TextStyle? whatsNewStyle,
    TextStyle? contentStyle,
    TextStyle? buttonTextStyle,
    bool? showHandle,
    bool? showBorder,
    double? borderWidth,
    String? updateAvailableTitle,
    String? upToDateTitle,
    String? versionPrefix,
    String? upToDateMessage,
    String? whatsNewLabel,
    String? notNowButton,
    String? updateNowButton,
    String? okayButton,
    String? readyToDownload,
    String? startingDownload,
    String? downloadingPrefix,
    String? installingUpdate,
    String? updateInstalled,
    String? installationFailed,
    String? checksumError,
    String? permissionDenied,
    String? internalError,
    String? downloadError,
    String? alreadyRunningError,
    String? unknownError,
    String? updateCancelled,
    String? unableToFetchTitle,
    String? noInternetMessage,
  }) async {
    // This package only supports Android
    if (!Platform.isAndroid) return false;

    final updateLogic = UpdateLogic(
      githubRepo: githubRepo,
      androidProviderAuthority: androidProviderAuthority,
    );

    // Clean up any old APK files from previous runs to save space
    await updateLogic.cleanupUpdateFiles();

    // Check for internet connectivity first
    final bool hasInternet = await UpdateUtils.hasInternet();

    // Resolve themes
    final localTheme = UpdateCheckerThemeData(
      backgroundColor: backgroundColor,
      textColor: textColor,
      secondaryTextColor: secondaryTextColor,
      accentColor: accentColor,
      accentTextColor: accentTextColor,
      pillColor: pillColor,
      boxColor: boxColor,
      handleColor: handleColor,
      borderColor: borderColor,
      updateIcon: updateIcon,
      upToDateIcon: upToDateIcon,
      noInternetIcon: noInternetIcon,
      borderRadius: borderRadius,
      padding: padding,
      buttonBorderRadius: buttonBorderRadius,
      titleStyle: titleStyle,
      versionStyle: versionStyle,
      whatsNewStyle: whatsNewStyle,
      contentStyle: contentStyle,
      buttonTextStyle: buttonTextStyle,
      showHandle: showHandle,
      showBorder: showBorder,
      borderWidth: borderWidth,
      updateAvailableTitle: updateAvailableTitle,
      upToDateTitle: upToDateTitle,
      versionPrefix: versionPrefix,
      upToDateMessage: upToDateMessage,
      whatsNewLabel: whatsNewLabel,
      notNowButton: notNowButton,
      updateNowButton: updateNowButton,
      okayButton: okayButton,
      readyToDownload: readyToDownload,
      startingDownload: startingDownload,
      downloadingPrefix: downloadingPrefix,
      installingUpdate: installingUpdate,
      updateInstalled: updateInstalled,
      installationFailed: installationFailed,
      checksumError: checksumError,
      permissionDenied: permissionDenied,
      internalError: internalError,
      downloadError: downloadError,
      alreadyRunningError: alreadyRunningError,
      unknownError: unknownError,
      updateCancelled: updateCancelled,
      unableToFetchTitle: unableToFetchTitle,
      noInternetMessage: noInternetMessage,
    );

    final mergedTheme = theme?.mergeWith(localTheme) ?? localTheme;

    if (!hasInternet) {
      if (showIfUpToDate && context.mounted) {
        switch (style) {
          case UpdateCheckerStyle.bottomSheet:
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => UpdateBottomSheet(
                githubRepo: githubRepo,
                androidProviderAuthority: androidProviderAuthority,
                themeData: mergedTheme,
                latestVersion: "",
                releaseNotes: "",
                showNetworkError: true,
                enableHaptics: enableHaptics,
                showRedirectButton: showRedirectButton,
              ),
            );
            break;
          case UpdateCheckerStyle.alertDialog:
            showDialog(
              context: context,
              builder: (context) => _buildUpdateDialog(
                githubRepo: githubRepo,
                androidProviderAuthority: androidProviderAuthority,
                themeData: mergedTheme,
                latestVersion: "",
                downloadUrl: null,
                releaseNotes: "",
                isUpToDate: true,
                showNetworkError: true,
                enableHaptics: enableHaptics,
                showRedirectButton: showRedirectButton,
              ),
            );
            break;
        }
        return true;
      }
      return false;
    }

    final updateData = await updateLogic.checkLatestVersionInfo();

    if (updateData == null) return false;

    final bool isUpdateAvailable = updateData['isUpdateAvailable'] ?? false;

    if (isUpdateAvailable || showIfUpToDate) {
      if (context.mounted) {
        switch (style) {
          case UpdateCheckerStyle.bottomSheet:
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => UpdateBottomSheet(
                githubRepo: githubRepo,
                androidProviderAuthority: androidProviderAuthority,
                themeData: mergedTheme,
                latestVersion: updateData['latestVersion'],
                downloadUrl: updateData['url'],
                releaseNotes: updateData['notes'],
                isUpToDate: !isUpdateAvailable,
                enableHaptics: enableHaptics,
                showRedirectButton: showRedirectButton,
              ),
            );
            break;
          case UpdateCheckerStyle.alertDialog:
            showDialog(
              context: context,
              builder: (context) => _buildUpdateDialog(
                githubRepo: githubRepo,
                androidProviderAuthority: androidProviderAuthority,
                themeData: mergedTheme,
                latestVersion: updateData['latestVersion'],
                downloadUrl: updateData['url'],
                releaseNotes: updateData['notes'],
                isUpToDate: !isUpdateAvailable,
                showNetworkError: false,
                enableHaptics: enableHaptics,
                showRedirectButton: showRedirectButton,
              ),
            );
            break;
        }
        return true;
      }
    }

    return false;
  }
}
