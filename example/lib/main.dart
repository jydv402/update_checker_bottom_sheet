import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Mocking the app version so that it triggers an update.
  // ignore: invalid_use_of_visible_for_testing_member
  PackageInfo.setMockInitialValues(
    appName: 'Example App',
    packageName: 'com.example.example',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: 'mock_signature',
  );

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // A nice dark theme to match the beautiful UI we want.
    return MaterialApp(
      title: 'Update Checker Example',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          onPrimary: Colors.white,
          surfaceContainerHigh: Color(0xFF1E1E1E),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isChecking = false;

  Future<void> _checkForUpdates(bool showIfUpToDate) async {
    setState(() {
      _isChecking = true;
    });

    // We use the static checkAndUpdate method to trigger the process.
    final updateFound = await UpdateCheckerBottomSheet.checkAndUpdate(
      context,
      // Whether to show the bottom sheet even if the app is up to date.
      showIfUpToDate: showIfUpToDate,
      // The main configuration object for the update checker.
      config: UpdateCheckerConfig(
        // The GitHub repository to check for releases (Required).
        githubRepo: "jydv402/memno",
        // Optional: Custom Android Provider Authority for OTA updates.
        // If null, it defaults to [packageName].update_checker_bottom_sheet.provider
        androidProviderAuthority: null,
        // Define all custom colors for the UI.
        bottomSheetColors: const UpdateBottomSheetColors(
          // Background color of the bottom sheet itself.
          backgroundColor: Color(0xFF0F0F0F),
          // Primary text color for titles and descriptions.
          textColor: Colors.white,
          // Secondary text color for sub-titles and metadata.
          secondaryTextColor: Colors.white70,
          // Accent color for progress bars, icons, and primary buttons.
          accentColor: Colors.deepPurpleAccent,
          // Text color on top of the accent color.
          accentTextColor: Colors.white,
          // Background color for the release notes container.
          pillColor: Color(0xFF1A1A1A),
          // Background color for the progress bar track.
          boxColor: Colors.white10,
          // Custom color for the top grabber/handle.
          handleColor: Colors.white30,
          // Custom color for the bottom sheet border.
          borderColor: Colors.white12,
        ),
        // Define all custom visual styles for the UI.
        bottomSheetStyles: const UpdateBottomSheetStyles(
          // Icon shown when an update is available.
          updateIcon: Icons.cloud_download_rounded,
          // Icon shown when the app is already up to date.
          upToDateIcon: Icons.verified_rounded,
          // Icon shown when no internet connection is detected.
          noInternetIcon: Icons.wifi_off_rounded,
          // Corner radius for the top edges of the bottom sheet.
          borderRadius: 30,
          // Corner radius for all buttons in the bottom sheet.
          buttonBorderRadius: 16,
          // Inner padding around the entire content.
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          // Whether to show the top grabber/handle.
          showHandle: true,
          // Whether to show a border around the bottom sheet.
          showBorder: true,
          // Width of the border.
          borderWidth: 1.5,
          // Custom text style for the main title.
          titleStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // Custom text style for the version/status text.
          versionStyle: TextStyle(fontSize: 16, color: Colors.white70),
          // Custom text style for the "What's New" label.
          whatsNewStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          // Custom text style for the release notes content.
          contentStyle: TextStyle(
            fontSize: 14,
            color: Colors.white,
            height: 1.5,
          ),
          // Custom text style for the buttons.
          buttonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // Define all custom strings for localization or personalization.
        bottomSheetStrings: const UpdateBottomSheetStrings(
          // Title when an update is found.
          updateAvailableTitle: "New Version Available",
          // Title when no update is found.
          upToDateTitle: "You're All Set!",
          // Prefix for the version number.
          versionPrefix: "Build",
          // Message when the app is on the latest version.
          upToDateMessage: "You are already using the latest features.",
          // Label for the release notes section.
          whatsNewLabel: "Release Highlights:",
          // Text for the "cancel" button.
          notNowButton: "Later",
          // Text for the "confirm" button.
          updateNowButton: "Upgrade Now",
          // Text for the "dismiss" button.
          okayButton: "Got it",
          // Status before download starts.
          readyToDownload: "Connecting to server...",
          // Status while initializing download.
          startingDownload: "Fetching files...",
          // Status prefix during active download.
          downloadingPrefix: "Progress",
          // Status when sending to system installer.
          installingUpdate: "Preparing installation...",
          // Status after successful trigger.
          updateInstalled: "Ready to install.",
          // Error: Installer failed.
          installationFailed: "Failed to start installer.",
          // Error: Checksum mismatch.
          checksumError: "File integrity check failed.",
          // Error: Permission missing.
          permissionDenied: "Storage access is required.",
          // Error: Internal exception.
          internalError: "Something went wrong internally.",
          // Error: Network failure.
          downloadError: "Network connection lost.",
          // Error: Update already in progress.
          alreadyRunningError: "Another update is active.",
          // Error: Generic fallback.
          unknownError: "An unexpected error occurred.",
          // Message when user cancels download.
          updateCancelled: "Download paused/cancelled.",
          // Title for internet connection errors.
          unableToFetchTitle: "Check Connection",
          // Message for internet connection errors.
          noInternetMessage: "Please verify your internet and try again.",
        ),
      ),
    );

    setState(() {
      _isChecking = false;
    });

    if (!updateFound && mounted && !showIfUpToDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No updates found! You are on the latest version.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Checker Example'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.system_update_alt_rounded,
              size: 80,
              color: Colors.white54,
            ),
            const SizedBox(height: 24),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Current Mock Version: ${snapshot.data?.version}',
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  );
                }
                return const CircularProgressIndicator(color: Colors.white);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isChecking ? null : () => _checkForUpdates(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isChecking
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Check for Updates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
