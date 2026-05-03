import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

import 'config.dart';
import 'update_logic.dart';

class UpdateBottomSheet extends StatefulWidget {
  final UpdateCheckerConfig config;
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;

  const UpdateBottomSheet({
    super.key,
    required this.config,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
  });

  @override
  State<UpdateBottomSheet> createState() => _UpdateBottomSheetState();
}

class _UpdateBottomSheetState extends State<UpdateBottomSheet> {
  bool _isDownloading = false;
  double _progress = 0;
  String _statusMessage = "Ready to download";
  StreamSubscription<OtaEvent>? _otaSubscription;
  late final UpdateLogic _updateLogic;

  @override
  void initState() {
    super.initState();
    _updateLogic = UpdateLogic(widget.config);
  }

  @override
  void dispose() {
    _otaSubscription?.cancel();
    super.dispose();
  }

  void _startDownload() {
    setState(() {
      _isDownloading = true;
      _statusMessage = "Starting download...";
    });

    try {
      _otaSubscription = _updateLogic
          .startOtaUpdate(widget.downloadUrl)
          .listen(
            (OtaEvent event) {
              setState(() {
                switch (event.status) {
                  case OtaStatus.DOWNLOADING:
                    _progress = double.tryParse(event.value ?? "0") ?? 0;
                    _statusMessage = "Downloading: ${_progress.toInt()}%";
                    break;
                  case OtaStatus.INSTALLING:
                    _statusMessage = "Installing update...";
                    break;
                  case OtaStatus.INSTALLATION_DONE:
                    _statusMessage = "Update installed.";
                    _isDownloading = false;
                    break;
                  case OtaStatus.INSTALLATION_ERROR:
                    _statusMessage = "Installation failed.";
                    _isDownloading = false;
                    break;
                  case OtaStatus.CHECKSUM_ERROR:
                    _statusMessage = "Checksum error. Try again later.";
                    _isDownloading = false;
                    break;
                  case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                    _statusMessage = "Permission not granted.";
                    _isDownloading = false;
                    break;
                  case OtaStatus.INTERNAL_ERROR:
                    _statusMessage = "An internal error occurred.";
                    _isDownloading = false;
                    break;
                  case OtaStatus.DOWNLOAD_ERROR:
                    _statusMessage = "File could not be downloaded.";
                    _isDownloading = false;
                    break;
                  case OtaStatus.ALREADY_RUNNING_ERROR:
                    _statusMessage = "An update is already in progress.";
                    break;
                  default:
                    _statusMessage = "Something went wrong.";
                    _isDownloading = false;
                    break;
                }
              });
            },
            onError: (e) {
              setState(() {
                _statusMessage = "Download failed: $e";
                _isDownloading = false;
              });
            },
          );
    } catch (e) {
      setState(() {
        _statusMessage = "Failed to initialize update: $e";
        _isDownloading = false;
      });
    }
  }

  void _cancelDownload() async {
    try {
      await OtaUpdate().cancel();
      _otaSubscription?.cancel();
      // Ensure cleanup after cancellation
      await _updateLogic.cleanupUpdateFiles();
      setState(() {
        _isDownloading = false;
        _progress = 0;
        _statusMessage = "Download cancelled.";
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Update cancelled')));
      }
    } catch (e) {
      debugPrint("Error cancelling download: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = widget.config.bottomSheetColors;

    final bgColor = customColors?.backgroundColor ?? theme.canvasColor;
    final txtColor =
        customColors?.textColor ??
        theme.textTheme.bodyLarge?.color ??
        Colors.black;
    final subTxtColor =
        customColors?.secondaryTextColor ?? txtColor.withValues(alpha: 0.6);
    final accColor = customColors?.accentColor ?? theme.primaryColor;
    final accTxtColor =
        customColors?.accentTextColor ?? theme.colorScheme.onPrimary;
    final pllColor =
        customColors?.pillColor ?? theme.dialogTheme.backgroundColor ?? theme.colorScheme.surfaceContainerHigh;
    final bxColor = customColors?.boxColor ?? theme.dividerColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Available",
                    style: TextStyle(
                      color: txtColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Version ${widget.latestVersion}",
                    style: TextStyle(color: subTxtColor, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update_alt_rounded,
                  color: accTxtColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "What's New:",
            style: TextStyle(
              color: txtColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: pllColor,
              borderRadius: BorderRadius.circular(20),
            ),
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: Text(
                widget.releaseNotes,
                style: TextStyle(color: txtColor, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (_isDownloading)
            Column(
              children: [
                LinearProgressIndicator(
                  value: _progress / 100,
                  backgroundColor: bxColor,
                  valueColor: AlwaysStoppedAnimation<Color>(accColor),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _statusMessage,
                      style: TextStyle(color: txtColor, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: _cancelDownload,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      side: BorderSide(
                        color: txtColor.withValues(alpha: 0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text("Not Now", style: TextStyle(color: txtColor)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _startDownload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accColor,
                      foregroundColor: accTxtColor,
                      padding: const EdgeInsets.all(18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "Update Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
