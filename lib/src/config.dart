import 'package:flutter/material.dart';

/// Configuration for the Update Checker
class UpdateCheckerConfig {
  /// The GitHub repository to check for releases.
  /// Example: "jydv402/memno"
  final String githubRepo;

  /// The Android Provider Authority used by ota_update.
  /// If null, it defaults to "[packageName].update_checker_bottom_sheet.provider"
  /// using the bundled FileProvider configuration.
  final String? androidProviderAuthority;

  /// Optional custom colors for the bottom sheet UI.
  final UpdateBottomSheetColors bottomSheetColors;

  /// Optional custom styles for the bottom sheet UI (radius, padding, icons, etc).
  final UpdateBottomSheetStyles bottomSheetStyles;

  /// Optional custom strings for the bottom sheet UI (localization).
  final UpdateBottomSheetStrings bottomSheetStrings;

  const UpdateCheckerConfig({
    required this.githubRepo,
    this.androidProviderAuthority,
    this.bottomSheetColors = const UpdateBottomSheetColors(),
    this.bottomSheetStyles = const UpdateBottomSheetStyles(),
    this.bottomSheetStrings = const UpdateBottomSheetStrings(),
  });
}

/// Custom colors for the Update Bottom Sheet.
/// If values are null, they will fall back to theme defaults in the UI.
class UpdateBottomSheetColors {
  /// Background color of the bottom sheet
  final Color? backgroundColor;

  /// Primary text color
  final Color? textColor;

  /// Secondary/Subtext color
  final Color? secondaryTextColor;

  /// Accent color used for progress bar, icons, and primary buttons
  final Color? accentColor;

  /// Text color on top of the accent color (e.g. text on primary button)
  final Color? accentTextColor;

  /// Background color for the release notes pill/box
  final Color? pillColor;

  /// Background color for the progress bar track
  final Color? boxColor;

  const UpdateBottomSheetColors({
    this.backgroundColor,
    this.textColor,
    this.secondaryTextColor,
    this.accentColor,
    this.accentTextColor,
    this.pillColor,
    this.boxColor,
  });
}

/// Custom styles for the Update Bottom Sheet
class UpdateBottomSheetStyles {
  /// Icon to show when an update is available. Default: [Icons.system_update_alt_rounded]
  final IconData updateIcon;

  /// Icon to show when the app is up to date. Default: [Icons.check_circle_outline_rounded]
  final IconData upToDateIcon;

  /// Radius of the top corners of the bottom sheet. Default: 35
  final double borderRadius;

  /// Padding around the content of the bottom sheet.
  /// Default: [EdgeInsets.fromLTRB(24, 32, 24, 32)]
  final EdgeInsets padding;

  /// Radius of the buttons (Update Now, Not Now, Okay). Default: 50
  final double buttonBorderRadius;

  /// Custom text style for the main title.
  final TextStyle? titleStyle;

  /// Custom text style for the version number/status sub-title.
  final TextStyle? versionStyle;

  /// Custom text style for the "What's New" label.
  final TextStyle? whatsNewStyle;

  /// Custom text style for the release notes content.
  final TextStyle? contentStyle;

  /// Custom text style for the buttons.
  final TextStyle? buttonTextStyle;

  const UpdateBottomSheetStyles({
    this.updateIcon = Icons.system_update_alt_rounded,
    this.upToDateIcon = Icons.check_circle_outline_rounded,
    this.borderRadius = 35.0,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 32),
    this.buttonBorderRadius = 50.0,
    this.titleStyle,
    this.versionStyle,
    this.whatsNewStyle,
    this.contentStyle,
    this.buttonTextStyle,
  });
}

/// Custom strings for the Update Bottom Sheet (Localization support)
class UpdateBottomSheetStrings {
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

  const UpdateBottomSheetStrings({
    this.updateAvailableTitle = "Update Available",
    this.upToDateTitle = "Up to Date",
    this.versionPrefix = "Version",
    this.upToDateMessage = "You are using the latest version",
    this.whatsNewLabel = "What's New:",
    this.notNowButton = "Not Now",
    this.updateNowButton = "Update Now",
    this.okayButton = "Okay",
    this.readyToDownload = "Ready to download",
    this.startingDownload = "Starting download...",
    this.downloadingPrefix = "Downloading",
    this.installingUpdate = "Installing update...",
    this.updateInstalled = "Update installed.",
    this.installationFailed = "Installation failed.",
    this.checksumError = "Checksum error. Try again later.",
    this.permissionDenied = "Permission not granted.",
    this.internalError = "An internal error occurred.",
    this.downloadError = "File could not be downloaded.",
    this.alreadyRunningError = "An update is already in progress.",
    this.unknownError = "Something went wrong.",
    this.updateCancelled = "Update cancelled",
  });
}
