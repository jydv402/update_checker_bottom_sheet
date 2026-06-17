import 'dart:io';

import 'package:flutter/material.dart';
import 'src/utils.dart';
import 'src/theme.dart';
import 'src/update_logic.dart';
import 'src/update_bottom_sheet.dart';

export 'src/theme.dart';

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

  /// Checks for updates and triggers the bottom sheet UI if needed.
  ///
  /// returns `true` if the update UI was displayed, and `false` otherwise.
  static Future<bool> check(
    BuildContext context, {
    required String githubRepo,
    bool showIfUpToDate = true,
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
            githubRepo: githubRepo,
            androidProviderAuthority: androidProviderAuthority,
            themeData: mergedTheme,
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
