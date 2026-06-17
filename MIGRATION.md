# Migration Guide: Upgrading from 0.0.5 to 0.0.6

Version `0.0.6` introduces a major architecture rework to simplify usage, flatten parameters, and align with standard Flutter practices. This guide details the breaking changes and how to migrate your code.

---

## 🚨 Breaking Changes Summary

1. **Renamed Class**: `UpdateCheckerBottomSheet` has been renamed to `UpdateChecker`.
2. **Simplified Method**: `checkAndUpdate` has been renamed to `check`.
3. **Configuration Classes Removed**: The nested configuration classes (`UpdateCheckerConfig`, `UpdateBottomSheetColors`, `UpdateBottomSheetStyles`, `UpdateBottomSheetStrings`) have been completely removed.
4. **Flat Customization Parameters**: Styling, coloring, and custom strings are now passed as flat optional parameters directly to the `UpdateChecker.check` method.
5. **Global Theme Configuration**: Added static `UpdateChecker.theme` property using `UpdateCheckerThemeData` to manage styling globally without wrapping your app in inherited widgets.

---

## 🛠️ Step-by-Step Migration

### 1. Update Imports and Version
Ensure your `pubspec.yaml` uses the latest version:
```yaml
dependencies:
  update_checker_bottom_sheet: ^0.0.6
```

Keep your existing import:
```dart
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';
```

---

### 2. Update Update Check Logic

#### Before (0.0.5)
Nested configuration classes were required:
```dart
UpdateCheckerBottomSheet.checkAndUpdate(
  context,
  config: const UpdateCheckerConfig(
    githubRepo: "username/repo",
    bottomSheetColors: UpdateBottomSheetColors(
      backgroundColor: Colors.black,
      textColor: Colors.white,
    ),
    bottomSheetStyles: UpdateBottomSheetStyles(
      borderRadius: 30,
    ),
  ),
);
```

#### After (0.0.6) - Method A: Flat Parameters
Pass settings directly as flat arguments:
```dart
UpdateChecker.check(
  context,
  githubRepo: "username/repo",
  backgroundColor: Colors.black,
  textColor: Colors.white,
  borderRadius: 30,
);
```

#### After (0.0.6) - Method B: Global Theme (Recommended)
Define configurations once globally (e.g. in your `main()` function) using the static `UpdateChecker.theme` property:
```dart
void main() {
  UpdateChecker.theme = const UpdateCheckerThemeData(
    backgroundColor: Colors.black,
    textColor: Colors.white,
    borderRadius: 30,
  );
  runApp(const MyApp());
}
```
And then execute a simple check anywhere in your app:
```dart
UpdateChecker.check(context, githubRepo: "username/repo");
```

---

### 3. Check for Updates on Startup
To check for updates automatically when your app/screen launches, simply invoke `UpdateChecker.check` inside the `initState` of your home screen wrapped in a post-frame callback:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Setting showIfUpToDate to false prevents interrupting the user if they're on the latest version.
    UpdateChecker.check(
      context, 
      githubRepo: "username/repo",
      showIfUpToDate: false,
    );
  });
}
```
