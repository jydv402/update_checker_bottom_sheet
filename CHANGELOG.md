# 0.0.7

* **Dual Presentation Styles**: Added an optional `style` parameter to `UpdateChecker.check(...)` so updates can be shown as either a bottom sheet or an alert dialog while keeping the bottom sheet as the default.
* **Markdown Release Notes**: Enabled Markdown rendering for the release notes box so GitHub release descriptions with headings, lists, and emphasis display correctly in the update UI.
* **Haptic Feedback Support**: Added support for enabling haptic feedback in the update checker buttons. Controlled via the boolean flag `enableHaptics`.

## 0.0.6

* **Singular Static Entry Point**: Unified the check process under the singular static method `UpdateChecker.check(...)`. Removed the stateful widget wrapper for a cleaner, native-like Flutter development experience.
* **Flattened Parameters**: Replaced all nested configuration classes (`UpdateCheckerConfig`, `UpdateBottomSheetColors`, etc.) with simple, flat optional parameters directly on `UpdateChecker.check(...)`.
* **Global Theming Support**: Introduced the static `UpdateChecker.theme` property using `UpdateCheckerThemeData` to configure styles, colors, and strings globally without widget wrapping.
* **Network Error Mismatch Fix**: Fixed a bug where the "Unable to Fetch" bottom sheet was displayed on internet failure even when `showIfUpToDate` was set to `false`.
* **Decoupled Architecture**: Separated the core logic of check and update (`UpdateLogic`) from presentation and style parameters.

## 0.0.5

* **Internet availability check**: Added native logic for checking if the device has internet connectivity before checking for updates.
* **No internet UI**: Added a new bottom sheet UI for displaying a no internet message when the device has no internet connectivity.
* **Internal updates**: Improved internal documentation with comprehensive `dartdoc` comments for all public and internal classes.

## 0.0.4

* **Android-Only Support**: Updated `README.md` and `pubspec.yaml` to reflect that the package is designed exclusively for Android.
* **Documentation Improvements**: Enhanced `README.md` with:
    * A clearer platform support statement.
    * A new "Supported Platforms" section detailing the Android-only nature and reason.
    * A "Sample Implementation" link for easy integration guidance.
* **Internal Updates**: Improved internal documentation with comprehensive `dartdoc` comments for all public and internal classes.
* **Metadata Refinement**: Updated `pubspec.yaml` metadata for better pub.dev analysis and clarity.

## 0.0.3

* Updated dependencies and improved metadata for pub.dev.
* Fixed issue where APK selection might fail on certain build variants.

## 0.0.2

* Added support for automated APK cleanup after updates.
* Enhanced customization options for icons and text styles.

## 0.0.1

* Initial release.
* Check for app updates via GitHub Releases.
* Premium, customizable bottom sheet UI.
* Automated OTA downloading and installation on Android.
* Smart architecture detection (ABI aware).
* "Up to Date" status notification mode.
* Deep customization for colors, styles, and strings (localization-ready).
* Plug-and-play setup with automated permissions and FileProvider.
