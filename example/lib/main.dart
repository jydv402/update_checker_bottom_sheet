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

  @override
  void initState() {
    super.initState();
    // Check for updates automatically on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates(false);
    });
  }

  Future<void> _checkForUpdates(bool showIfUpToDate) async {
    setState(() {
      _isChecking = true;
    });

    // We use the static check method to trigger the process.
    final updateFound = await UpdateChecker.check(
      context,
      style: UpdateCheckerStyle.bottomSheet,
      githubRepo: "jydv402/memno",
      // Whether to provide haptics feedback.
      enableHaptics: true,
      // Whether to show the bottom sheet even if the app is up to date.
      showIfUpToDate: showIfUpToDate,
      // Whether to show a button that redirects to the GitHub repository.
      showRedirectButton: false,
      // Define all custom colors for the UI.
      backgroundColor: const Color(0xFF0F0F0F),
      textColor: Colors.white,
      secondaryTextColor: Colors.white70,
      accentColor: Colors.deepPurpleAccent,
      accentTextColor: Colors.white,
      pillColor: const Color(0xFF1A1A1A),
      boxColor: Colors.white10,
      handleColor: Colors.white30,
      borderColor: Colors.white12,
      updateIcon: Icons.cloud_download_rounded,
      upToDateIcon: Icons.verified_rounded,
      noInternetIcon: Icons.wifi_off_rounded,
      borderRadius: 30,
      buttonBorderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      showHandle: true,
      showBorder: true,
      borderWidth: 1.5,
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      versionStyle: const TextStyle(fontSize: 16, color: Colors.white70),
      whatsNewStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      contentStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        height: 1.5,
      ),
      buttonTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      updateAvailableTitle: "New Version Available",
      upToDateTitle: "You're All Set!",
      versionPrefix: "Build",
      upToDateMessage: "You are already using the latest features.",
      whatsNewLabel: "Release Highlights:",
      notNowButton: "Later",
      updateNowButton: "Upgrade Now",
      okayButton: "Got it",
      readyToDownload: "Connecting to server...",
      startingDownload: "Fetching files...",
      downloadingPrefix: "Progress",
      installingUpdate: "Preparing installation...",
      updateInstalled: "Ready to install.",
      installationFailed: "Failed to start installer.",
      checksumError: "File integrity check failed.",
      permissionDenied: "Storage access is required.",
      internalError: "Something went wrong internally.",
      downloadError: "Network connection lost.",
      alreadyRunningError: "Another update is active.",
      unknownError: "An unexpected error occurred.",
      updateCancelled: "Download cancelled.",
      unableToFetchTitle: "Check Connection",
      noInternetMessage: "Please verify your internet and try again.",
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
              onPressed: _isChecking ? null : () => _checkForUpdates(true),
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
