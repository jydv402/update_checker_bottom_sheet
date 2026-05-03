# Implementation Guide

This guide describes the two primary ways to integrate the `UpdateCheckerBottomSheet` into your Flutter application.

---

## 1. Automatic Check on App Open

The most common pattern is to check for updates as soon as the app starts. You can place the logic in your root widget's `initState` or inside your `main.dart` after the app is initialized.

### Example: Using `initState`
This ensures the check runs every time the main screen is loaded.

```dart
import 'package:flutter/material.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    await UpdateCheckerBottomSheet.checkAndUpdate(
      context,
      config: const UpdateCheckerConfig(
        githubRepo: "username/repo",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: const Center(child: Text("Welcome!")),
    );
  }
}
```

---

## 2. Explicit Check on Button Tap

You might want to allow users to manually check for updates, typically from a **Settings** or **About** page. In this case, you should use `showIfUpToDate: true` so the user gets feedback even if they are on the latest version.

### Example: Settings Button
```dart
ListTile(
  leading: const Icon(Icons.update),
  title: const Text("Check for Updates"),
  subtitle: const Text("Check if a newer version is available on GitHub"),
  onTap: () async {
    // Show a loading indicator if desired
    final result = await UpdateCheckerBottomSheet.checkAndUpdate(
      context,
      showIfUpToDate: true, // Crucial for manual checks!
      config: const UpdateCheckerConfig(
        githubRepo: "username/repo",
      ),
    );
    
    // Optional: result is true if the bottom sheet was shown
    if (!result) {
      debugPrint("Update check failed or interrupted.");
    }
  },
)
```

---

## 💡 Pro Tips

- **Context Readiness**: When calling `checkAndUpdate` on app start, always use `WidgetsBinding.instance.addPostFrameCallback` to avoid "context not ready" errors.
- **Cleanup**: The package automatically cleans up any partially downloaded APK files from previous sessions every time `checkAndUpdate` is called, ensuring your app's storage footprint remains small.
- **GitHub Rate Limits**: For public repositories, GitHub API has a rate limit. Avoid calling the update check too frequently (e.g., on every page navigation).
