# Deep Customization Guide 🎨

The `update_checker_bottom_sheet` package offers extensive customization options to ensure the update UI fits perfectly with your app's branding. 

Customizations can be applied globally using `UpdateChecker.theme` or passed locally as flat parameters directly inside `UpdateChecker.check()`.

---

## 📌 Customization Methods

### Method 1: Global Theme (Recommended)
Configure the styles once at app startup (e.g., in your `main()` function) using `UpdateChecker.theme`:

```dart
void main() {
  UpdateChecker.theme = const UpdateCheckerThemeData(
    backgroundColor: Color(0xFF121212),
    textColor: Colors.white,
    accentColor: Colors.deepPurpleAccent,
    borderRadius: 30,
    updateAvailableTitle: "New Update Available",
  );
  runApp(const MyApp());
}
```

### Method 2: Local Parameters
Override global styles on a per-call basis by passing parameters directly to `UpdateChecker.check()`:

```dart
UpdateChecker.check(
  context,
  githubRepo: "username/repo",
  // Local overrides:
  backgroundColor: Colors.blueGrey,
  accentColor: Colors.cyan,
);
```

---

## 🌈 Colors

Control the color palette of the bottom sheet. If a value is left null, it will intelligently fall back to your app's `ThemeData` defaults.

| Parameter | Description | Fallback |
| :--- | :--- | :--- |
| `backgroundColor` | The main background of the sheet. | `Theme.of(context).canvasColor` |
| `textColor` | The primary text color for titles. | `Theme.of(context).textTheme.bodyLarge` |
| `secondaryTextColor` | Used for version sub-titles and subtext. | `textColor` with 60% opacity |
| `accentColor` | Used for the progress bar, icons, and primary buttons. | `Theme.of(context).primaryColor` |
| `accentTextColor` | Text color when on top of an accent color. | `Theme.of(context).colorScheme.onPrimary` |
| `pillColor` | Background for the "What's New" release notes box. | `Theme.of(context).surfaceContainerHigh` |
| `boxColor` | Background for the progress bar track. | `Theme.of(context).dividerColor` |
| `handleColor` | Color of the top grabber handle. | `secondaryTextColor` |
| `borderColor` | Color of the sheet border. | `Theme.of(context).dividerColor` |

---

## ✨ Styles

Modify the visual structure, icons, and typography of the sheet.

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `updateIcon` | Icon shown when an update is available. | `Icons.system_update_alt_rounded` |
| `upToDateIcon` | Icon shown in "Up to Date" mode. | `Icons.check_circle_outline_rounded` |
| `noInternetIcon` | Icon shown when network is unavailable. | `Icons.wifi_off_rounded` |
| `borderRadius` | Top corner radius of the bottom sheet. | `35.0` |
| `buttonBorderRadius` | Corner radius for all action buttons. | `50.0` |
| `padding` | Inner padding of the sheet content. | `EdgeInsets.fromLTRB(24, 32, 24, 32)` |
| `titleStyle` | Text style for the main title. | Bold, size 24 |
| `versionStyle` | Text style for the version/status text. | Size 16 |
| `whatsNewStyle` | Text style for the "What's New" label. | Bold, size 18 |
| `contentStyle` | Text style for release notes content. | Size 14 |
| `buttonTextStyle` | Text style for button labels. | Bold |
| `showHandle` | Whether to display the top grabber handle. | `true` |
| `showBorder` | Whether to show a border around the bottom sheet. | `false` |
| `borderWidth` | Width of the bottom sheet border. | `1.0` |

---

## 🌐 Strings

Perfect for localization or personalizing the message. You can override every single piece of text.

### Available String Parameters:
- **Titles**: `updateAvailableTitle`, `upToDateTitle`, `unableToFetchTitle`
- **Labels**: `versionPrefix`, `whatsNewLabel`, `upToDateMessage`, `noInternetMessage`
- **Buttons**: `updateNowButton`, `notNowButton`, `okayButton`
- **Statuses**: `readyToDownload`, `startingDownload`, `downloadingPrefix`, `installingUpdate`, `updateInstalled`, `updateCancelled`
- **Errors**: `downloadError`, `installationFailed`, `checksumError`, `permissionDenied`, `internalError`, `alreadyRunningError`, `unknownError`

### Example for Japanese Localization:
```dart
UpdateChecker.theme = const UpdateCheckerThemeData(
  updateAvailableTitle: "アップデートが利用可能です",
  upToDateTitle: "最新の状態です",
  updateNowButton: "今すぐ更新",
  notNowButton: "後で",
  whatsNewLabel: "新機能:",
);
```
