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
  final UpdateBottomSheetColors? bottomSheetColors;

  const UpdateCheckerConfig({
    required this.githubRepo,
    this.androidProviderAuthority,
    this.bottomSheetColors,
  });
}

/// Custom colors for the Update Bottom Sheet
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
