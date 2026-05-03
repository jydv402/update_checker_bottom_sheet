# Deep Customization Guide 🎨

The `update_checker_bottom_sheet` package offers extensive customization options to ensure the update UI fits perfectly with your app's branding. All customizations are managed through the `UpdateCheckerConfig` class.

## Table of Contents
- [Colors (`UpdateBottomSheetColors`)](#-colors-updatebottomsheetcolors)
- [Styles (`UpdateBottomSheetStyles`)](#-styles-updatebottomsheetstyles)
- [Strings (`UpdateBottomSheetStrings`)](#-strings-updatebottomsheetstrings)
- [Full Example](#-full-example)

---

## 🌈 Colors (`UpdateBottomSheetColors`)

Control the color palette of the bottom sheet. If a value is left null, it will intelligently fall back to your app's `ThemeData` defaults.

| Property | Description | Fallback |
| :--- | :--- | :--- |
| `backgroundColor` | The main background of the sheet. | `Theme.of(context).canvasColor` |
| `textColor` | The primary text color for titles. | `Theme.of(context).textTheme.bodyLarge` |
| `secondaryTextColor` | Used for version sub-titles and subtext. | `Theme.of(context).textTheme.bodySmall` |
| `accentColor` | Used for the progress bar, icons, and primary buttons. | `Theme.of(context).primaryColor` |
| `accentTextColor` | Text color when on top of an accent color. | `Theme.of(context).colorScheme.onPrimary` |
| `pillColor` | Background for the "What's New" release notes box. | `Theme.of(context).surfaceContainerHigh` |
| `boxColor` | Background for the progress bar track. | `Theme.of(context).dividerColor` |

### Example Usage:
```dart
const colors = UpdateBottomSheetColors(
  backgroundColor: Color(0xFF121212),
  textColor: Colors.white,
  accentColor: Colors.deepPurpleAccent,
  pillColor: Color(0xFF1E1E1E),
);
```

---

## ✨ Styles (`UpdateBottomSheetStyles`)

Modify the visual structure, icons, and typography of the sheet.

| Property | Description | Default |
| :--- | :--- | :--- |
| `updateIcon` | Icon shown when an update is available. | `Icons.system_update_alt_rounded` |
| `upToDateIcon` | Icon shown in "Up to Date" mode. | `Icons.check_circle_outline_rounded` |
| `borderRadius` | Top corner radius of the bottom sheet. | `35.0` |
| `buttonBorderRadius` | Corner radius for all action buttons. | `50.0` |
| `padding` | Inner padding of the sheet content. | `EdgeInsets.all(24.0)` |
| `titleStyle` | Text style for the main title. | Bold, size 22 |
| `versionStyle` | Text style for the version/status text. | Size 14 |
| `whatsNewStyle` | Text style for the "What's New" label. | Bold, size 16 |
| `contentStyle` | Text style for release notes content. | Size 14 |
| `buttonTextStyle` | Text style for button labels. | Bold |

---

## 🌐 Strings (`UpdateBottomSheetStrings`)

Perfect for localization or personalizing the message. You can override every single piece of text.

### Available Fields:
- **Titles**: `updateAvailableTitle`, `upToDateTitle`
- **Labels**: `versionPrefix`, `whatsNewLabel`, `upToDateMessage`
- **Buttons**: `updateNowButton`, `notNowButton`, `okayButton`
- **Statuses**: `readyToDownload`, `startingDownload`, `downloadingPrefix`, `installingUpdate`
- **Errors**: `downloadError`, `installationFailed`, `checksumError`, `permissionDenied`, `internalError`, `alreadyRunningError`, `unknownError`

### Example for Japanese Localization:
```dart
const strings = UpdateBottomSheetStrings(
  updateAvailableTitle: "アップデートが利用可能です",
  upToDateTitle: "最新の状態です",
  updateNowButton: "今すぐ更新",
  notNowButton: "後で",
  whatsNewLabel: "新機能:",
);
```

---

## 🔥 Full Example

Here is how you can combine everything into a `UpdateCheckerConfig`:

```dart
UpdateCheckerBottomSheet.checkAndUpdate(
  context,
  config: UpdateCheckerConfig(
    githubRepo: "username/repo",
    bottomSheetColors: const UpdateBottomSheetColors(
      backgroundColor: Colors.black,
      accentColor: Colors.orangeAccent,
      textColor: Colors.white,
    ),
    bottomSheetStyles: const UpdateBottomSheetStyles(
      borderRadius: 20.0,
      updateIcon: Icons.download_for_offline,
    ),
    bottomSheetStrings: const UpdateBottomSheetStrings(
      updateNowButton: "INSTALL NOW",
    ),
  ),
);
```
