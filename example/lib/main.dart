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

    final updateFound = await UpdateCheckerBottomSheet.checkAndUpdate(
      context,
      showIfUpToDate: showIfUpToDate,
      config: UpdateCheckerConfig(
        githubRepo: "jydv402/ZenUnni",
        bottomSheetColors: const UpdateBottomSheetColors(
          backgroundColor: Color(0xFF0F0F0F),
          accentColor: Colors.deepPurpleAccent,
          pillColor: Color(0xFF1A1A1A),
        ),
        bottomSheetStyles: UpdateBottomSheetStyles(
          borderRadius: 40,
          buttonBorderRadius: 15,
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
          updateIcon: Icons.cloud_download_rounded,
          upToDateIcon: Icons.verified_rounded,
          titleStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          buttonTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
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
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _isChecking ? null : () => _checkForUpdates(true),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurpleAccent,
                side: const BorderSide(color: Colors.deepPurpleAccent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Force Show Bottom Sheet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
