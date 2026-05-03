# Update Checker Bottom Sheet

A Flutter package to easily check for app updates via GitHub Releases and present a beautiful, customizable bottom sheet to the user to download and install the update.

## Features

- Checks for the latest release on a given GitHub repository.
- Compares semantic versioning to detect if an update is available.
- Presents a visually appealing bottom sheet with release notes and a progress bar.
- Handles downloading and installing the APK automatically.
- Fully customizable colors to match your app's theme.

## Getting started

### Android Setup

This package depends on `ota_update`, which requires Core Library Desugaring and a `FileProvider` setup for Android.

#### 1. Enable Core Library Desugaring

Open your app's `android/app/build.gradle` (or `build.gradle.kts`).

**Kotlin DSL (`build.gradle.kts`)**:
```kotlin
compileOptions {
    isCoreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

#### 2. Configure FileProvider

Add the following to your `AndroidManifest.xml` inside the `<application>` tag:

```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.ota_update_provider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/filepaths" />
</provider>
```

Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```

Create a file at `android/app/src/main/res/xml/filepaths.xml` with the following content:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <files-path name="internal_files" path="."/>
    <external-path name="external_files" path="."/>
    <external-cache-path name="external_cache_files" path="."/>
    <external-files-path name="external_main_files" path="."/>
</paths>
```


## Usage

Check the `/example` folder for a fully working sample.

```dart
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void _checkForUpdates() async {
  // Call this wherever you want to check for updates
  await UpdateCheckerBottomSheet.checkAndUpdate(
    context,
    config: const UpdateCheckerConfig(
      githubRepo: "jydv402/memno", // Your GitHub repository
      androidProviderAuthority: "com.your.app.ota_update_provider", // Your provider authority
      
      // Optional: Override colors
      bottomSheetColors: UpdateBottomSheetColors(
        backgroundColor: Colors.grey[900],
        accentColor: Colors.blueAccent,
      ),
    ),
  );
}
```
