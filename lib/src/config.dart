import 'package:flutter/material.dart';

/// Configuration for the Update Checker.
///
/// This class centralizes all the settings required to check for updates,
/// including the GitHub repository, custom UI colors, styles, and localized strings.
class UpdateCheckerConfig {
  /// The GitHub repository to check for releases.
  /// Example: "jydv402/memno"
  final String githubRepo;

  /// The Android Provider Authority used by ota_update.
  ///
  /// If null, it defaults to "[packageName].update_checker_bottom_sheet.provider"
  /// using the bundled FileProvider configuration in this package.
  final String? androidProviderAuthority;

  /// Optional custom colors for the bottom sheet UI.
  final UpdateBottomSheetColors bottomSheetColors;

  /// Optional custom styles for the bottom sheet UI (radius, padding, icons, etc).
  final UpdateBottomSheetStyles bottomSheetStyles;

  /// Optional custom strings for the bottom sheet UI (localization).
  final UpdateBottomSheetStrings bottomSheetStrings;

  /// Creates a configuration for the update checker.
  ///
  /// [githubRepo] is the GitHub repository to check for releases (e.g., "jydv402/memno").
  /// [androidProviderAuthority] is the optional custom authority for the FileProvider.
  /// [bottomSheetColors] defines the custom colors for the UI components.
  /// [bottomSheetStyles] defines the custom shapes, icons, and text styles.
  /// [bottomSheetStrings] defines the localized text and messages shown to the user.
  const UpdateCheckerConfig({
    required this.githubRepo,
    this.androidProviderAuthority,
    this.bottomSheetColors = const UpdateBottomSheetColors(),
    this.bottomSheetStyles = const UpdateBottomSheetStyles(),
    this.bottomSheetStrings = const UpdateBottomSheetStrings(),
  });
}

/// Custom colors for the Update Bottom Sheet UI.
///
/// If values are null, they will automatically fall back to the app's
/// current [ThemeData] defaults.
class UpdateBottomSheetColors {
  /// Background color of the bottom sheet itself.
  final Color? backgroundColor;

  /// Primary text color for titles and descriptions.
  final Color? textColor;

  /// Secondary text color for sub-titles and metadata.
  final Color? secondaryTextColor;

  /// Accent color used for the progress bar, action icons, and primary buttons.
  final Color? accentColor;

  /// Text color used on top of the accent color (e.g., text on the primary action button).
  final Color? accentTextColor;

  /// Background color for the release notes pill/box container.
  final Color? pillColor;

  /// Background color for the progress bar track.
  final Color? boxColor;

  /// Color of the top handle/grabber.
  final Color? handleColor;

  /// Color of the border around the bottom sheet.
  final Color? borderColor;

  /// Creates a set of custom colors for the bottom sheet.
  ///
  /// [backgroundColor] sets the background of the entire bottom sheet.
  /// [textColor] sets the primary text color (titles, descriptions).
  /// [secondaryTextColor] sets the secondary text color (sub-headers, metadata).
  /// [accentColor] sets the color for icons, progress bars, and primary buttons.
  /// [accentTextColor] sets the color of text/icons displayed on top of [accentColor].
  /// [pillColor] sets the background color for the release notes container.
  /// [boxColor] sets the background color for the progress bar track.
  const UpdateBottomSheetColors({
    this.backgroundColor,
    this.textColor,
    this.secondaryTextColor,
    this.accentColor,
    this.accentTextColor,
    this.pillColor,
    this.boxColor,
    this.handleColor,
    this.borderColor,
  });
}

/// Custom visual styles for the Update Bottom Sheet.
///
/// Allows fine-tuning the layout, icons, and typography of the update interface.
class UpdateBottomSheetStyles {
  /// Icon to show when a new update is available.
  /// Default: [Icons.system_update_alt_rounded]
  final IconData updateIcon;

  /// Icon to show when the app is already up to date.
  /// Default: [Icons.check_circle_outline_rounded]
  final IconData upToDateIcon;

  /// Corner radius of the top edges of the bottom sheet.
  /// Default: 35.0
  final double borderRadius;

  /// Inner padding around the entire content of the bottom sheet.
  /// Default: [EdgeInsets.fromLTRB(24, 32, 24, 32)]
  final EdgeInsets padding;

  /// Corner radius for all action buttons (Update Now, Not Now, Okay).
  /// Default: 50.0
  final double buttonBorderRadius;

  /// Custom text style for the main header title.
  final TextStyle? titleStyle;

  /// Custom text style for the version number or status sub-header.
  final TextStyle? versionStyle;

  /// Custom text style for the "What's New" label above release notes.
  final TextStyle? whatsNewStyle;

  /// Custom text style for the actual release notes content.
  final TextStyle? contentStyle;

  /// Custom text style for the buttons.
  final TextStyle? buttonTextStyle;

  /// Icon to show when the internet is not available. Default: [Icons.wifi_off_rounded]
  final IconData noInternetIcon;

  /// Whether to show the top handle/grabber. Default: true
  final bool showHandle;

  /// Whether to show a border around the bottom sheet. Default: false
  final bool showBorder;

  /// Width of the border. Default: 1.0
  final double borderWidth;

  /// Creates a set of custom styles for the bottom sheet.
  ///
  /// [updateIcon] is the icon shown when an update is available.
  /// [upToDateIcon] is the icon shown when the app is up to date.
  /// [borderRadius] is the corner radius of the bottom sheet top edges.
  /// [padding] is the inner padding around the bottom sheet content.
  /// [buttonBorderRadius] is the corner radius for all action buttons.
  /// [titleStyle] is the custom text style for the main title.
  /// [versionStyle] is the custom text style for the version sub-header.
  /// [whatsNewStyle] is the custom text style for the "What's New" label.
  /// [contentStyle] is the custom text style for the release notes and status messages.
  /// [buttonTextStyle] is the custom text style for button labels.
  /// [noInternetIcon] is the icon shown when the network is unavailable.
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
    this.noInternetIcon = Icons.wifi_off_rounded,
    this.showHandle = true,
    this.showBorder = false,
    this.borderWidth = 1.0,
  });
}

/// Custom strings for the Update Bottom Sheet (Localization support).
///
/// Use this class to translate the UI into other languages or to
/// personalize the messages shown to the user.
class UpdateBottomSheetStrings {
  /// Title shown when an update is found. Default: "Update Available"
  final String updateAvailableTitle;

  /// Title shown when no update is found. Default: "Up to Date"
  final String upToDateTitle;

  /// Text prefixed to the version number. Default: "Version"
  final String versionPrefix;

  /// Message shown when the app is already on the latest version.
  final String upToDateMessage;

  /// Label for the release notes section. Default: "What's New:"
  final String whatsNewLabel;

  /// Label for the negative action button. Default: "Not Now"
  final String notNowButton;

  /// Label for the positive action button. Default: "Update Now"
  final String updateNowButton;

  /// Label for the confirmation button. Default: "Okay"
  final String okayButton;

  /// Status text when the file is ready to be downloaded.
  final String readyToDownload;

  /// Status text when the download is being initialized.
  final String startingDownload;

  /// Text shown while downloading, usually followed by a percentage.
  final String downloadingPrefix;

  /// Status text when the APK is being sent to the system installer.
  final String installingUpdate;

  /// Status text when installation was successfully triggered.
  final String updateInstalled;

  /// Error message when the system installer fails.
  final String installationFailed;

  /// Error message for file integrity issues.
  final String checksumError;

  /// Error message when storage or install permissions are missing.
  final String permissionDenied;

  /// Error message for general internal exceptions.
  final String internalError;

  /// Error message when the network request fails.
  final String downloadError;

  /// Error message when another update process is already active.
  final String alreadyRunningError;

  /// Generic fallback error message.
  final String unknownError;

  /// Message shown if the user cancels the download process.
  final String updateCancelled;

  /// Title shown when the fetch fails due to internet. Default: "Unable to Fetch"
  final String unableToFetchTitle;

  /// Message shown when the internet is not available.
  final String noInternetMessage;

  /// Creates a localized set of strings for the UI.
  ///
  /// [updateAvailableTitle] is the title for the update alert.
  /// [upToDateTitle] is the title for the up-to-date alert.
  /// [versionPrefix] is the text shown before the version number.
  /// [upToDateMessage] is the message shown when no update is found.
  /// [whatsNewLabel] is the label for the release notes section.
  /// [notNowButton] is the text for the "cancel" button.
  /// [updateNowButton] is the text for the "confirm" button.
  /// [okayButton] is the text for the "dismiss" button.
  /// [readyToDownload] is the status before starting the download.
  /// [startingDownload] is the status when initializing the connection.
  /// [downloadingPrefix] is the status during active download.
  /// [installingUpdate] is the status when sending the file to the installer.
  /// [updateInstalled] is the status after successful installation trigger.
  /// [installationFailed] is the error message for installer failures.
  /// [checksumError] is the error message for invalid file downloads.
  /// [permissionDenied] is the error message for missing storage/install permissions.
  /// [internalError] is the error message for general exceptions.
  /// [downloadError] is the error message for network failures.
  /// [alreadyRunningError] is the error message when another update is active.
  /// [unknownError] is the error message for unhandled exceptions.
  /// [updateCancelled] is the message shown when the user cancels.
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
    this.unableToFetchTitle = "Unable to Fetch",
    this.noInternetMessage =
        "Please check your internet connection and try again.",
  });
}
