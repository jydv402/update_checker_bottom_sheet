# 0.0.5

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
