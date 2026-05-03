# Update Checker Bottom Sheet

A Flutter package to easily check for app updates via GitHub Releases and present a beautiful, customizable bottom sheet to the user to download and install the update.

## Features

- **Plug & Play**: Automated Android configuration (Manifest & FileProvider).
- **GitHub Integrated**: Fetches latest release, version, and notes from GitHub API.
- **Beautiful UI**: Modern, dark-themed bottom sheet with progress indicator.
- **OTA Updates**: Handles downloading and initiating APK installation automatically.
- **Customizable**: Override colors to match your brand.

## Getting started

### Android Setup

This package handles most of the Android configuration for you. You only need to enable **Core Library Desugaring** in your app's Gradle file.

1. Open `android/app/build.gradle` (or `build.gradle.kts`).
2. Add the following to your `compileOptions` and `dependencies`:

**Kotlin DSL (`build.gradle.kts`)**:
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

## Usage

Integrating the update checker is now extremely simple:

```dart
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void _checkForUpdates() async {
  await UpdateCheckerBottomSheet.checkAndUpdate(
    context,
    config: const UpdateCheckerConfig(
      githubRepo: "your_username/your_repo", // e.g. "jydv402/ZenUnni"
      
      // Optional: Custom colors
      bottomSheetColors: UpdateBottomSheetColors(
        backgroundColor: Color(0xFF121212),
        accentColor: Colors.deepPurpleAccent,
      ),
    ),
  );
}
```

### Optional: ProGuard Rules
If you use R8/ProGuard, you might need to keep the `ota_update` classes:
```proguard
-keep class sk.fourq.otaupdate.** { *; }
```

## How it works
- **Version Check**: The package compares your current `pubspec` version with the latest GitHub release tag (expected format: `v1.0.0` or `1.0.0`).
- **File Sharing**: Uses a bundled `FileProvider` with authority `${applicationId}.update_checker_bottom_sheet.provider`.
- **Permissions**: Automatically includes `INTERNET` and `REQUEST_INSTALL_PACKAGES` via the plugin manifest.
