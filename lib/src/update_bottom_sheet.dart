import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

import '../components/action_section.dart';
import '../components/header_section.dart';
import '../components/progress_section.dart';
import '../components/release_notes_section.dart';

import 'theme.dart';
import 'theme_resolver.dart';
import 'update_logic.dart';

class UpdateBottomSheet extends StatefulWidget {
  final String githubRepo;
  final String? androidProviderAuthority;
  final UpdateCheckerThemeData themeData;
  final String latestVersion;
  final String? downloadUrl;
  final String releaseNotes;
  final bool isUpToDate;
  final bool showNetworkError;
  final bool isDialogStyle;
  final bool enableHaptics;
  final bool showRedirectButton;

  const UpdateBottomSheet({
    super.key,
    required this.githubRepo,
    this.androidProviderAuthority,
    required this.themeData,
    required this.latestVersion,
    this.downloadUrl,
    required this.releaseNotes,
    this.isUpToDate = false,
    this.showNetworkError = false,
    this.isDialogStyle = false,
    this.enableHaptics = false,
    this.showRedirectButton = false,
  });

  @override
  State<UpdateBottomSheet> createState() => _UpdateBottomSheetState();
}

class _UpdateBottomSheetState extends State<UpdateBottomSheet> {
  bool _isDownloading = false;
  double _progress = 0;
  late String _statusMessage;
  StreamSubscription<OtaEvent>? _otaSubscription;
  late final UpdateLogic _updateLogic;
  late final ResolvedStrings _strings;

  @override
  void initState() {
    super.initState();
    _updateLogic = UpdateLogic(
      githubRepo: widget.githubRepo,
      androidProviderAuthority: widget.androidProviderAuthority,
    );
    _strings = ResolvedStrings.resolve(widget.themeData);
    _statusMessage = _strings.readyToDownload;
  }

  @override
  void dispose() {
    _otaSubscription?.cancel();
    super.dispose();
  }

  void _startDownload() {
    setState(() {
      _isDownloading = true;
      _statusMessage = _strings.startingDownload;
    });

    try {
      if (widget.downloadUrl == null) return;
      _otaSubscription = _updateLogic
          .startOtaUpdate(widget.downloadUrl!)
          .listen(
            (OtaEvent event) {
              setState(() {
                switch (event.status) {
                  case OtaStatus.DOWNLOADING:
                    _progress = double.tryParse(event.value ?? "0") ?? 0;
                    _statusMessage =
                        "${_strings.downloadingPrefix}: ${_progress.toInt()}%";
                    break;
                  case OtaStatus.INSTALLING:
                    _statusMessage = _strings.installingUpdate;
                    break;
                  case OtaStatus.INSTALLATION_DONE:
                    _statusMessage = _strings.updateInstalled;
                    _isDownloading = false;
                    break;
                  case OtaStatus.INSTALLATION_ERROR:
                    _statusMessage = _strings.installationFailed;
                    _isDownloading = false;
                    break;
                  case OtaStatus.CHECKSUM_ERROR:
                    _statusMessage = _strings.checksumError;
                    _isDownloading = false;
                    break;
                  case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                    _statusMessage = _strings.permissionDenied;
                    _isDownloading = false;
                    break;
                  case OtaStatus.INTERNAL_ERROR:
                    _statusMessage = _strings.internalError;
                    _isDownloading = false;
                    break;
                  case OtaStatus.DOWNLOAD_ERROR:
                    _statusMessage = _strings.downloadError;
                    _isDownloading = false;
                    break;
                  case OtaStatus.ALREADY_RUNNING_ERROR:
                    _statusMessage = _strings.alreadyRunningError;
                    break;
                  default:
                    _statusMessage = _strings.unknownError;
                    _isDownloading = false;
                    break;
                }
              });
            },
            onError: (e) {
              setState(() {
                _statusMessage = "${_strings.downloadError}: $e";
                _isDownloading = false;
              });
            },
          );
    } catch (e) {
      setState(() {
        _statusMessage = "${_strings.internalError}: $e";
        _isDownloading = false;
      });
    }
  }

  void _cancelDownload() async {
    try {
      await OtaUpdate().cancel();
      _otaSubscription?.cancel();
      await _updateLogic.cleanupUpdateFiles();
      setState(() {
        _isDownloading = false;
        _progress = 0;
        _statusMessage = _strings.readyToDownload;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_strings.updateCancelled)));
      }
    } catch (e) {
      debugPrint("Error cancelling download: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ResolvedColors.resolve(context, widget.themeData);
    final styles = ResolvedStyles.resolve(context, widget.themeData, colors);
    final strings = _strings;

    final borderRadius = widget.isDialogStyle
        ? BorderRadius.circular(styles.borderRadius)
        : BorderRadius.vertical(top: Radius.circular(styles.borderRadius));

    final border = widget.isDialogStyle
        ? (styles.showBorder
              ? Border.all(color: colors.borderColor, width: styles.borderWidth)
              : null)
        : (styles.showBorder
              ? Border(
                  top: BorderSide(
                    color: colors.borderColor,
                    width: styles.borderWidth,
                  ),
                  left: BorderSide(
                    color: colors.borderColor,
                    width: styles.borderWidth,
                  ),
                  right: BorderSide(
                    color: colors.borderColor,
                    width: styles.borderWidth,
                  ),
                )
              : null);

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: border,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          if (styles.showHandle) ...[
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.handleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],

          // Main content
          Padding(
            padding: styles.padding,
            child: Column(
              children: [
                HeaderSection(
                  isUpToDate: widget.isUpToDate,
                  showNetworkError: widget.showNetworkError,
                  latestVersion: widget.latestVersion,
                  colors: colors,
                  styles: styles,
                  strings: strings,
                ),
                if (!widget.showNetworkError) ...[
                  const SizedBox(height: 20),
                  ReleaseNotesSection(
                    releaseNotes: widget.releaseNotes,
                    colors: colors,
                    styles: styles,
                    strings: strings,
                  ),
                ],
                const SizedBox(height: 20),
                if (_isDownloading)
                  ProgressSection(
                    progress: _progress,
                    statusMessage: _statusMessage,
                    onCancel: _cancelDownload,
                    enableHaptics: widget.enableHaptics,
                    colors: colors,
                    styles: styles,
                  )
                else
                  ActionsSection(
                    isUpToDate: widget.isUpToDate || widget.showNetworkError,
                    onUpdate: _startDownload,
                    enableHaptics: widget.enableHaptics,
                    showRedirectButton: widget.showRedirectButton,
                    githubRepo: widget.githubRepo,
                    colors: colors,
                    styles: styles,
                    strings: strings,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
