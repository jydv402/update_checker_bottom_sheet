import 'package:flutter/material.dart';

import '../update_checker_bottom_sheet.dart';

class ResolvedColors {
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final Color accentTextColor;
  final Color pillColor;
  final Color boxColor;
  final Color handleColor;
  final Color borderColor;

  ResolvedColors({
    required this.backgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.accentTextColor,
    required this.pillColor,
    required this.boxColor,
    required this.handleColor,
    required this.borderColor,
  });

  factory ResolvedColors.resolve(
    BuildContext context,
    UpdateCheckerThemeData custom,
  ) {
    final theme = Theme.of(context);
    final txtColor =
        custom.textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black;
    final secTextColor =
        custom.secondaryTextColor ?? txtColor.withValues(alpha: 0.6);

    return ResolvedColors(
      backgroundColor: custom.backgroundColor ?? theme.canvasColor,
      textColor: txtColor,
      secondaryTextColor: secTextColor,
      accentColor: custom.accentColor ?? theme.primaryColor,
      accentTextColor: custom.accentTextColor ?? theme.colorScheme.onPrimary,
      pillColor:
          custom.pillColor ??
          theme.dialogTheme.backgroundColor ??
          theme.colorScheme.surfaceContainerHigh,
      boxColor: custom.boxColor ?? theme.dividerColor,
      handleColor: custom.handleColor ?? secTextColor,
      borderColor: custom.borderColor ?? theme.dividerColor,
    );
  }
}

class ResolvedStyles {
  final IconData updateIcon;
  final IconData upToDateIcon;
  final double borderRadius;
  final EdgeInsets padding;
  final double buttonBorderRadius;
  final TextStyle titleStyle;
  final TextStyle versionStyle;
  final TextStyle whatsNewStyle;
  final TextStyle contentStyle;
  final TextStyle primaryButtonTextStyle;
  final TextStyle secondaryButtonTextStyle;
  final IconData noInternetIcon;
  final bool showHandle;
  final bool showBorder;
  final double borderWidth;

  ResolvedStyles({
    required this.updateIcon,
    required this.upToDateIcon,
    required this.borderRadius,
    required this.padding,
    required this.buttonBorderRadius,
    required this.titleStyle,
    required this.versionStyle,
    required this.whatsNewStyle,
    required this.contentStyle,
    required this.primaryButtonTextStyle,
    required this.secondaryButtonTextStyle,
    required this.noInternetIcon,
    required this.showHandle,
    required this.showBorder,
    required this.borderWidth,
  });

  factory ResolvedStyles.resolve(
    BuildContext context,
    UpdateCheckerThemeData custom,
    ResolvedColors colors,
  ) {
    return ResolvedStyles(
      updateIcon: custom.updateIcon ?? Icons.system_update_alt_rounded,
      upToDateIcon: custom.upToDateIcon ?? Icons.check_circle_outline_rounded,
      borderRadius: custom.borderRadius ?? 35.0,
      padding: custom.padding ?? const EdgeInsets.fromLTRB(24, 32, 24, 32),
      buttonBorderRadius: custom.buttonBorderRadius ?? 50.0,
      titleStyle:
          custom.titleStyle ??
          TextStyle(
            color: colors.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
      versionStyle:
          custom.versionStyle ??
          TextStyle(color: colors.secondaryTextColor, fontSize: 16),
      whatsNewStyle:
          custom.whatsNewStyle ??
          TextStyle(
            color: colors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
      contentStyle:
          custom.contentStyle ??
          TextStyle(color: colors.textColor, fontSize: 14),
      primaryButtonTextStyle:
          custom.buttonTextStyle ??
          const TextStyle(fontWeight: FontWeight.bold),
      secondaryButtonTextStyle:
          custom.buttonTextStyle ?? TextStyle(color: colors.textColor),
      noInternetIcon: custom.noInternetIcon ?? Icons.wifi_off_rounded,
      showHandle: custom.showHandle ?? true,
      showBorder: custom.showBorder ?? false,
      borderWidth: custom.borderWidth ?? 1.0,
    );
  }
}

class ResolvedStrings {
  final String updateAvailableTitle;
  final String upToDateTitle;
  final String versionPrefix;
  final String upToDateMessage;
  final String whatsNewLabel;
  final String notNowButton;
  final String updateNowButton;
  final String okayButton;
  final String readyToDownload;
  final String startingDownload;
  final String downloadingPrefix;
  final String installingUpdate;
  final String updateInstalled;
  final String installationFailed;
  final String checksumError;
  final String permissionDenied;
  final String internalError;
  final String downloadError;
  final String alreadyRunningError;
  final String unknownError;
  final String updateCancelled;
  final String unableToFetchTitle;
  final String noInternetMessage;

  ResolvedStrings({
    required this.updateAvailableTitle,
    required this.upToDateTitle,
    required this.versionPrefix,
    required this.upToDateMessage,
    required this.whatsNewLabel,
    required this.notNowButton,
    required this.updateNowButton,
    required this.okayButton,
    required this.readyToDownload,
    required this.startingDownload,
    required this.downloadingPrefix,
    required this.installingUpdate,
    required this.updateInstalled,
    required this.installationFailed,
    required this.checksumError,
    required this.permissionDenied,
    required this.internalError,
    required this.downloadError,
    required this.alreadyRunningError,
    required this.unknownError,
    required this.updateCancelled,
    required this.unableToFetchTitle,
    required this.noInternetMessage,
  });

  factory ResolvedStrings.resolve(UpdateCheckerThemeData custom) {
    return ResolvedStrings(
      updateAvailableTitle: custom.updateAvailableTitle ?? "Update Available",
      upToDateTitle: custom.upToDateTitle ?? "Up to Date",
      versionPrefix: custom.versionPrefix ?? "Version",
      upToDateMessage:
          custom.upToDateMessage ?? "You are using the latest version",
      whatsNewLabel: custom.whatsNewLabel ?? "What's New:",
      notNowButton: custom.notNowButton ?? "Not Now",
      updateNowButton: custom.updateNowButton ?? "Update Now",
      okayButton: custom.okayButton ?? "Okay",
      readyToDownload: custom.readyToDownload ?? "Ready to download",
      startingDownload: custom.startingDownload ?? "Starting download...",
      downloadingPrefix: custom.downloadingPrefix ?? "Downloading",
      installingUpdate: custom.installingUpdate ?? "Installing update...",
      updateInstalled: custom.updateInstalled ?? "Update installed.",
      installationFailed: custom.installationFailed ?? "Installation failed.",
      checksumError: custom.checksumError ?? "Checksum error. Try again later.",
      permissionDenied: custom.permissionDenied ?? "Permission not granted.",
      internalError: custom.internalError ?? "An internal error occurred.",
      downloadError: custom.downloadError ?? "File could not be downloaded.",
      alreadyRunningError:
          custom.alreadyRunningError ?? "An update is already in progress.",
      unknownError: custom.unknownError ?? "Something went wrong.",
      updateCancelled: custom.updateCancelled ?? "Update cancelled",
      unableToFetchTitle: custom.unableToFetchTitle ?? "Unable to Fetch",
      noInternetMessage:
          custom.noInternetMessage ??
          "Please check your internet connection and try again.",
    );
  }
}
