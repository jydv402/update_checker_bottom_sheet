import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

import 'config.dart';
import 'update_logic.dart';

class UpdateBottomSheet extends StatefulWidget {
  final UpdateCheckerConfig config;
  final String latestVersion;
  final String? downloadUrl;
  final String releaseNotes;
  final bool isUpToDate;

  const UpdateBottomSheet({
    super.key,
    required this.config,
    required this.latestVersion,
    this.downloadUrl,
    required this.releaseNotes,
    this.isUpToDate = false,
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

  @override
  void initState() {
    super.initState();
    _updateLogic = UpdateLogic(widget.config);
    _statusMessage = widget.config.bottomSheetStrings.readyToDownload;
  }

  @override
  void dispose() {
    _otaSubscription?.cancel();
    super.dispose();
  }

  void _startDownload() {
    final strings = widget.config.bottomSheetStrings;
    setState(() {
      _isDownloading = true;
      _statusMessage = strings.startingDownload;
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
                        "${strings.downloadingPrefix}: ${_progress.toInt()}%";
                    break;
                  case OtaStatus.INSTALLING:
                    _statusMessage = strings.installingUpdate;
                    break;
                  case OtaStatus.INSTALLATION_DONE:
                    _statusMessage = strings.updateInstalled;
                    _isDownloading = false;
                    break;
                  case OtaStatus.INSTALLATION_ERROR:
                    _statusMessage = strings.installationFailed;
                    _isDownloading = false;
                    break;
                  case OtaStatus.CHECKSUM_ERROR:
                    _statusMessage = strings.checksumError;
                    _isDownloading = false;
                    break;
                  case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                    _statusMessage = strings.permissionDenied;
                    _isDownloading = false;
                    break;
                  case OtaStatus.INTERNAL_ERROR:
                    _statusMessage = strings.internalError;
                    _isDownloading = false;
                    break;
                  case OtaStatus.DOWNLOAD_ERROR:
                    _statusMessage = strings.downloadError;
                    _isDownloading = false;
                    break;
                  case OtaStatus.ALREADY_RUNNING_ERROR:
                    _statusMessage = strings.alreadyRunningError;
                    break;
                  default:
                    _statusMessage = strings.unknownError;
                    _isDownloading = false;
                    break;
                }
              });
            },
            onError: (e) {
              setState(() {
                _statusMessage = "${strings.downloadError}: $e";
                _isDownloading = false;
              });
            },
          );
    } catch (e) {
      setState(() {
        _statusMessage = "${strings.internalError}: $e";
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
        _statusMessage = widget.config.bottomSheetStrings.readyToDownload;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.config.bottomSheetStrings.updateCancelled),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error cancelling download: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _ResolvedColors.resolve(
      context,
      widget.config.bottomSheetColors,
    );
    final styles = widget.config.bottomSheetStyles;
    final strings = widget.config.bottomSheetStrings;

    return Container(
      padding: styles.padding,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(styles.borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(
            isUpToDate: widget.isUpToDate,
            latestVersion: widget.latestVersion,
            colors: colors,
            styles: styles,
            strings: strings,
          ),
          const SizedBox(height: 20),
          _ReleaseNotesSection(
            releaseNotes: widget.releaseNotes,
            colors: colors,
            styles: styles,
            strings: strings,
          ),
          const SizedBox(height: 30),
          if (_isDownloading)
            _ProgressSection(
              progress: _progress,
              statusMessage: _statusMessage,
              onCancel: _cancelDownload,
              colors: colors,
              styles: styles,
            )
          else
            _ActionsSection(
              isUpToDate: widget.isUpToDate,
              onUpdate: _startDownload,
              colors: colors,
              styles: styles,
              strings: strings,
            ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final bool isUpToDate;
  final String latestVersion;
  final _ResolvedColors colors;
  final UpdateBottomSheetStyles styles;
  final UpdateBottomSheetStrings strings;

  const _HeaderSection({
    required this.isUpToDate,
    required this.latestVersion,
    required this.colors,
    required this.styles,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUpToDate ? strings.upToDateTitle : strings.updateAvailableTitle,
              style:
                  styles.titleStyle ??
                  TextStyle(
                    color: colors.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              isUpToDate
                  ? strings.upToDateMessage
                  : "${strings.versionPrefix} $latestVersion",
              style:
                  styles.versionStyle ??
                  TextStyle(color: colors.secondaryTextColor, fontSize: 16),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.accentColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isUpToDate ? styles.upToDateIcon : styles.updateIcon,
            color: colors.accentTextColor,
          ),
        ),
      ],
    );
  }
}

class _ReleaseNotesSection extends StatelessWidget {
  final String releaseNotes;
  final _ResolvedColors colors;
  final UpdateBottomSheetStyles styles;
  final UpdateBottomSheetStrings strings;

  const _ReleaseNotesSection({
    required this.releaseNotes,
    required this.colors,
    required this.styles,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.whatsNewLabel,
          style:
              styles.whatsNewStyle ??
              TextStyle(
                color: colors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.pillColor,
            borderRadius: BorderRadius.circular(20),
          ),
          constraints: const BoxConstraints(maxHeight: 150),
          child: SingleChildScrollView(
            child: Text(
              releaseNotes,
              style:
                  styles.contentStyle ??
                  TextStyle(color: colors.textColor, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final String statusMessage;
  final VoidCallback onCancel;
  final _ResolvedColors colors;
  final UpdateBottomSheetStyles styles;

  const _ProgressSection({
    required this.progress,
    required this.statusMessage,
    required this.onCancel,
    required this.colors,
    required this.styles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: colors.boxColor,
          valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
          borderRadius: BorderRadius.circular(10),
          minHeight: 10,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                statusMessage,
                style:
                    styles.contentStyle ??
                    TextStyle(color: colors.textColor, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: onCancel,
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {
  final bool isUpToDate;
  final VoidCallback onUpdate;
  final _ResolvedColors colors;
  final UpdateBottomSheetStyles styles;
  final UpdateBottomSheetStrings strings;

  const _ActionsSection({
    required this.isUpToDate,
    required this.onUpdate,
    required this.colors,
    required this.styles,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    if (isUpToDate) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.accentColor,
            foregroundColor: colors.accentTextColor,
            padding: const EdgeInsets.all(18),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(styles.buttonBorderRadius),
            ),
          ),
          child: Text(
            strings.okayButton,
            style:
                styles.buttonTextStyle ??
                const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(18),
              side: BorderSide(color: colors.textColor.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(styles.buttonBorderRadius),
              ),
            ),
            child: Text(
              strings.notNowButton,
              style:
                  styles.buttonTextStyle ?? TextStyle(color: colors.textColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accentColor,
              foregroundColor: colors.accentTextColor,
              padding: const EdgeInsets.all(18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(styles.buttonBorderRadius),
              ),
            ),
            child: Text(
              strings.updateNowButton,
              style:
                  styles.buttonTextStyle ??
                  const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResolvedColors {
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final Color accentTextColor;
  final Color pillColor;
  final Color boxColor;

  _ResolvedColors({
    required this.backgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.accentTextColor,
    required this.pillColor,
    required this.boxColor,
  });

  factory _ResolvedColors.resolve(
    BuildContext context,
    UpdateBottomSheetColors custom,
  ) {
    final theme = Theme.of(context);
    final txtColor =
        custom.textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black;

    return _ResolvedColors(
      backgroundColor: custom.backgroundColor ?? theme.canvasColor,
      textColor: txtColor,
      secondaryTextColor:
          custom.secondaryTextColor ?? txtColor.withValues(alpha: 0.6),
      accentColor: custom.accentColor ?? theme.primaryColor,
      accentTextColor: custom.accentTextColor ?? theme.colorScheme.onPrimary,
      pillColor:
          custom.pillColor ??
          theme.dialogTheme.backgroundColor ??
          theme.colorScheme.surfaceContainerHigh,
      boxColor: custom.boxColor ?? theme.dividerColor,
    );
  }
}
