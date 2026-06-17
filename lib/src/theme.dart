import 'package:flutter/material.dart';

/// Configuration options for styling, colors, and strings inside the Update Checker.
///
/// This class merges global theme settings and individual call overrides.
class UpdateCheckerThemeData {
  // Colors
  final Color? backgroundColor;
  final Color? textColor;
  final Color? secondaryTextColor;
  final Color? accentColor;
  final Color? accentTextColor;
  final Color? pillColor;
  final Color? boxColor;
  final Color? handleColor;
  final Color? borderColor;

  // Styles
  final IconData? updateIcon;
  final IconData? upToDateIcon;
  final IconData? noInternetIcon;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? buttonBorderRadius;
  final TextStyle? titleStyle;
  final TextStyle? versionStyle;
  final TextStyle? whatsNewStyle;
  final TextStyle? contentStyle;
  final TextStyle? buttonTextStyle;
  final bool? showHandle;
  final bool? showBorder;
  final double? borderWidth;

  // Strings
  final String? updateAvailableTitle;
  final String? upToDateTitle;
  final String? versionPrefix;
  final String? upToDateMessage;
  final String? whatsNewLabel;
  final String? notNowButton;
  final String? updateNowButton;
  final String? okayButton;
  final String? readyToDownload;
  final String? startingDownload;
  final String? downloadingPrefix;
  final String? installingUpdate;
  final String? updateInstalled;
  final String? installationFailed;
  final String? checksumError;
  final String? permissionDenied;
  final String? internalError;
  final String? downloadError;
  final String? alreadyRunningError;
  final String? unknownError;
  final String? updateCancelled;
  final String? unableToFetchTitle;
  final String? noInternetMessage;

  /// Creates a unified set of configuration options.
  const UpdateCheckerThemeData({
    this.backgroundColor,
    this.textColor,
    this.secondaryTextColor,
    this.accentColor,
    this.accentTextColor,
    this.pillColor,
    this.boxColor,
    this.handleColor,
    this.borderColor,
    this.updateIcon,
    this.upToDateIcon,
    this.noInternetIcon,
    this.borderRadius,
    this.padding,
    this.buttonBorderRadius,
    this.titleStyle,
    this.versionStyle,
    this.whatsNewStyle,
    this.contentStyle,
    this.buttonTextStyle,
    this.showHandle,
    this.showBorder,
    this.borderWidth,
    this.updateAvailableTitle,
    this.upToDateTitle,
    this.versionPrefix,
    this.upToDateMessage,
    this.whatsNewLabel,
    this.notNowButton,
    this.updateNowButton,
    this.okayButton,
    this.readyToDownload,
    this.startingDownload,
    this.downloadingPrefix,
    this.installingUpdate,
    this.updateInstalled,
    this.installationFailed,
    this.checksumError,
    this.permissionDenied,
    this.internalError,
    this.downloadError,
    this.alreadyRunningError,
    this.unknownError,
    this.updateCancelled,
    this.unableToFetchTitle,
    this.noInternetMessage,
  });

  /// Merges this theme data with a local set of overrides.
  ///
  /// Null values in [local] will fall back to values in this instance.
  UpdateCheckerThemeData mergeWith(UpdateCheckerThemeData? local) {
    if (local == null) return this;
    return UpdateCheckerThemeData(
      backgroundColor: local.backgroundColor ?? backgroundColor,
      textColor: local.textColor ?? textColor,
      secondaryTextColor: local.secondaryTextColor ?? secondaryTextColor,
      accentColor: local.accentColor ?? accentColor,
      accentTextColor: local.accentTextColor ?? accentTextColor,
      pillColor: local.pillColor ?? pillColor,
      boxColor: local.boxColor ?? boxColor,
      handleColor: local.handleColor ?? handleColor,
      borderColor: local.borderColor ?? borderColor,
      updateIcon: local.updateIcon ?? updateIcon,
      upToDateIcon: local.upToDateIcon ?? upToDateIcon,
      noInternetIcon: local.noInternetIcon ?? noInternetIcon,
      borderRadius: local.borderRadius ?? borderRadius,
      padding: local.padding ?? padding,
      buttonBorderRadius: local.buttonBorderRadius ?? buttonBorderRadius,
      titleStyle: local.titleStyle ?? titleStyle,
      versionStyle: local.versionStyle ?? versionStyle,
      whatsNewStyle: local.whatsNewStyle ?? whatsNewStyle,
      contentStyle: local.contentStyle ?? contentStyle,
      buttonTextStyle: local.buttonTextStyle ?? buttonTextStyle,
      showHandle: local.showHandle ?? showHandle,
      showBorder: local.showBorder ?? showBorder,
      borderWidth: local.borderWidth ?? borderWidth,
      updateAvailableTitle: local.updateAvailableTitle ?? updateAvailableTitle,
      upToDateTitle: local.upToDateTitle ?? upToDateTitle,
      versionPrefix: local.versionPrefix ?? versionPrefix,
      upToDateMessage: local.upToDateMessage ?? upToDateMessage,
      whatsNewLabel: local.whatsNewLabel ?? whatsNewLabel,
      notNowButton: local.notNowButton ?? notNowButton,
      updateNowButton: local.updateNowButton ?? updateNowButton,
      okayButton: local.okayButton ?? okayButton,
      readyToDownload: local.readyToDownload ?? readyToDownload,
      startingDownload: local.startingDownload ?? startingDownload,
      downloadingPrefix: local.downloadingPrefix ?? downloadingPrefix,
      installingUpdate: local.installingUpdate ?? installingUpdate,
      updateInstalled: local.updateInstalled ?? updateInstalled,
      installationFailed: local.installationFailed ?? installationFailed,
      checksumError: local.checksumError ?? checksumError,
      permissionDenied: local.permissionDenied ?? permissionDenied,
      internalError: local.internalError ?? internalError,
      downloadError: local.downloadError ?? downloadError,
      alreadyRunningError: local.alreadyRunningError ?? alreadyRunningError,
      unknownError: local.unknownError ?? unknownError,
      updateCancelled: local.updateCancelled ?? updateCancelled,
      unableToFetchTitle: local.unableToFetchTitle ?? unableToFetchTitle,
      noInternetMessage: local.noInternetMessage ?? noInternetMessage,
    );
  }
}

/// An [InheritedWidget] to define global [UpdateCheckerThemeData] settings.
class UpdateCheckerTheme extends InheritedWidget {
  final UpdateCheckerThemeData data;

  const UpdateCheckerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static UpdateCheckerThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UpdateCheckerTheme>()?.data;
  }

  @override
  bool updateShouldNotify(UpdateCheckerTheme oldWidget) => data != oldWidget.data;
}
