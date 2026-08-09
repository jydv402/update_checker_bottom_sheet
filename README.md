# Update Checker Bottom Sheet

[![Pub Version](https://img.shields.io/pub/v/update_checker_bottom_sheet?color=blue)](https://pub.dev/packages/update_checker_bottom_sheet)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A simple and customizable Flutter package to check for app updates via **GitHub Releases**. It provides a beautiful, user-friendly update UI that can be shown as either a bottom sheet or an alert dialog, handling version comparison, OTA downloading, and installation on Android.

---

## 📌 Index
- [Screenshots](#-screenshots)
- [Features](#-features)
- [Installation](#-installation)
- [Android Setup](#-android-setup)
- [Usage](#-usage)
- [Customization](#-customization)
- [Migration Guide (0.0.5 to 0.0.6)](#-migration-guide)
- [GitHub Release Best Practices (Important)](#-github-release-best-practices-important)
- [Note on Versioning (Important)](#-note-on-versioning-important)
- [License](#-license)

---
## 📸 Screenshots

| Update Available | Downloading | Installing |
| :---: | :---: | :---: |
| ![Update Available](https://raw.githubusercontent.com/jydv402/update_checker_bottom_sheet/main/assets/screenshots/update_available.png) | ![Downloading](https://raw.githubusercontent.com/jydv402/update_checker_bottom_sheet/main/assets/screenshots/downloading.png) | ![Installing](https://raw.githubusercontent.com/jydv402/update_checker_bottom_sheet/main/assets/screenshots/installing.png) |

## 📱 Supported Platforms

- ✅ Android
- ❌ iOS
- ❌ Web
- ❌ macOS
- ❌ Windows
- ❌ Linux

Currently, this package is designed **exclusively for Android**. 

The underlying OTA (Over-The-Air) engine utilizes Android's `FileProvider` and Package Installer to handle APK downloads and installation. Support for other platforms (iOS, Windows, etc.) is not planned for the immediate future due to the specific requirements of OTA distribution on those systems.

## ✨ Features


- **Android Native Support**: Built specifically for Android with 100% compatibility for current build systems.
- **OTA Updates**: Handles the full lifecycle—fetching, downloading, and triggering the Android Package Installer.
- **GitHub Integration**: Automatically parses latest release tags, changelogs, and APK assets.
- **Architecture Awareness**: Intelligently detects device ABI (`arm64-v8a`, `armeabi-v7a`, `x86_64`) and selects the matching APK.
- **"Up to Date" Notification**: Optionally show a success UI if no update is found.

---

## 📦 Installation

Add this package to your `pubspec.yaml` via **pub.dev**:

```yaml
dependencies:
  update_checker_bottom_sheet: ^0.0.7
```

Or Run

```bash
flutter pub add update_checker_bottom_sheet
```

---

## 🛠️ Android Setup

This package is designed for maximum simplicity. The only manual requirement is enabling **Core Library Desugaring**.

### 1. Enable Desugaring
The underlying OTA engine requires desugaring to support older Android versions.

**`android/app/build.gradle` (or `build.gradle.kts`)**:
```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

### 2. Permissions
The package automatically bundles the necessary permissions:
- `INTERNET`
- `REQUEST_INSTALL_PACKAGES`
- `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE`

---

## 📖 Usage

### Simple Check
Automatically checks GitHub and shows the sheet only if an update is found.

```dart
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void _checkForUpdates() async {
  await UpdateChecker.check(
    context,
    githubRepo: "username/repo", // e.g. "jydv402/memno"
  );
}
```

### Alert Dialog Style
Choose a dialog-based presentation instead of the default bottom sheet.

```dart
await UpdateChecker.check(
  context,
  githubRepo: "username/repo",
  style: UpdateCheckerStyle.alertDialog,
);
```

### Optional repository redirect button
Open the latest GitHub release page directly from the update UI.

```dart
await UpdateChecker.check(
  context,
  githubRepo: "username/repo",
  showRedirectButton: true,
);
```

### Force "Up to Date" UI
Useful for "Check for Updates" buttons in a Settings menu.

```dart
await UpdateChecker.check(
  context,
  showIfUpToDate: true, // Shows "You are using the latest version" if no update
  githubRepo: "username/repo",
);
```

### ⚠️ Important: Cleaning Up Old APK Files
The `check` function automatically cleans up old APK files from previous downloads to save storage space on the user's device. This ensures a smooth user experience without cluttering the device with temporary files.

👉 **[View the Sample Implementation](https://github.com/jydv402/update_checker_bottom_sheet/blob/main/IMPLEMENTATION.md)**

---

## 🎨 Customization

We believe in deep customization. You can control every pixel, color, and string used in the bottom sheet.

👉 **[View the Full Customization Guide](https://github.com/jydv402/update_checker_bottom_sheet/blob/main/CUSTOMIZATION.md)**

---

## 🔄 Migration Guide

Upgrading from `0.0.5` to `0.0.6` contains breaking changes (renaming class/methods and flattening customization parameters).

👉 **[View the Migration Guide](https://github.com/jydv402/update_checker_bottom_sheet/blob/main/MIGRATION.md)**

---

## 🤖 GitHub Release Best Practices (IMPORTANT)

> [!IMPORTANT]
> To ensure the package correctly identifies and downloads your APKs, follow these guidelines when creating a GitHub Release:

1.  **ABI Naming**: The package looks for ABI names in the asset filenames. If your release has multiple APKs, name them like so:
    - `app-arm64-v8a-release.apk`
    - `app-armeabi-v7a-release.apk`
    - `app-x86_64-release.apk`
2.  **Split per ABI**: Use `flutter build apk --split-per-abi` to generate these files automatically.
3.  **Fallback Support**: If no ABI-specific match is found, the package will fallback to assets named `universal.apk` or `app-release.apk`.
4.  **Changelog**: The text in the GitHub Release "Description" field is automatically pulled and displayed as the "What's New" content.

---

## 📝 Note on Versioning (IMPORTANT)

> [!IMPORTANT]
> Version comparison is the core of this package. Here is how it works:

- **Semantic Versioning**: It compares your local version (from `pubspec.yaml`) with the **GitHub Release Tag**.
- **Build Numbers**: It supports and compares build numbers (e.g., `1.2.0+5` is recognized as newer than `1.2.0+4`).
- **Tag Formatting**: It gracefully handles `v` prefixes (e.g., Tag `v1.0.0` matches Version `1.0.0`).
- **Pre-releases**: Ensure your tags follow standard semantic versioning for predictable results.

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](https://github.com/jydv402/update_checker_bottom_sheet/blob/main/LICENSE) file for details.
