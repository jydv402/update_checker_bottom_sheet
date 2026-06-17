import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

import 'theme.dart';
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
  late final _ResolvedStrings _strings;

  @override
  void initState() {
    super.initState();
    _updateLogic = UpdateLogic(
      githubRepo: widget.githubRepo,
      androidProviderAuthority: widget.androidProviderAuthority,
    );
    _strings = _ResolvedStrings.resolve(widget.themeData);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_strings.updateCancelled),
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
      widget.themeData,
    );
    final styles = _ResolvedStyles.resolve(
      context,
      widget.themeData,
      colors,
    );
    final strings = _strings;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: styles.showBorder
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
            : null,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(styles.borderRadius),
        ),
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
                _HeaderSection(
                  isUpToDate: widget.isUpToDate,
                  showNetworkError: widget.showNetworkError,
                  latestVersion: widget.latestVersion,
                  colors: colors,
                  styles: styles,
                  strings: strings,
                ),
                if (!widget.showNetworkError) ...[
                  const SizedBox(height: 20),
                  _ReleaseNotesSection(
                    releaseNotes: widget.releaseNotes,
                    colors: colors,
                    styles: styles,
                    strings: strings,
                  ),
                ],
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
                    isUpToDate: widget.isUpToDate || widget.showNetworkError,
                    onUpdate: _startDownload,
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

class _HeaderSection extends StatelessWidget {
  final bool isUpToDate;
  final bool showNetworkError;
  final String latestVersion;
  final _ResolvedColors colors;
  final _ResolvedStyles styles;
  final _ResolvedStrings strings;

  const _HeaderSection({
    required this.isUpToDate,
    required this.showNetworkError,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                showNetworkError
                    ? strings.unableToFetchTitle
                    : isUpToDate
                    ? strings.upToDateTitle
                    : strings.updateAvailableTitle,
                style: styles.titleStyle,
              ),
              Text(
                showNetworkError
                    ? strings.noInternetMessage
                    : isUpToDate
                    ? strings.upToDateMessage
                    : "${strings.versionPrefix} $latestVersion",
                style: styles.versionStyle,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.accentColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            showNetworkError
                ? styles.noInternetIcon
                : isUpToDate
                ? styles.upToDateIcon
                : styles.updateIcon,
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
  final _ResolvedStyles styles;
  final _ResolvedStrings strings;

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
          style: styles.whatsNewStyle,
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
              style: styles.contentStyle,
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
  final _ResolvedStyles styles;

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
                style: styles.contentStyle,
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
  final _ResolvedStyles styles;
  final _ResolvedStrings strings;

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
            style: styles.primaryButtonTextStyle,
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
              style: styles.secondaryButtonTextStyle,
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
              style: styles.primaryButtonTextStyle,
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
  final Color handleColor;
  final Color borderColor;

  _ResolvedColors({
    required this.backgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.accentTextColor,
    required this.pillColor,
    required this.boxColor,
    required this.handleColor,
    required this.borderColor,
  });

  factory _ResolvedColors.resolve(
    BuildContext context,
    UpdateCheckerThemeData custom,
  ) {
    final theme = Theme.of(context);
    final txtColor =
        custom.textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black;
    final secTextColor =
        custom.secondaryTextColor ?? txtColor.withValues(alpha: 0.6);

    return _ResolvedColors(
      backgroundColor: custom.backgroundColor ?? theme.canvasColor,
      textColor: txtColor,
      secondaryTextColor: secTextColor,
      accentColor: custom.accentColor ?? theme.primaryColor,
      accentTextColor: custom.accentTextColor ?? theme.colorScheme.onPrimary,
      pillColor:
          custom.pillColor ??
          theme.dialogTheme.backgroundColor ??
          theme.colorScheme.surfaceContainerHigh,
      boxColor: custom.boxColor ?? theme.dividerColor,
      handleColor: custom.handleColor ?? secTextColor,
      borderColor: custom.borderColor ?? theme.dividerColor,
    );
  }
}

class _ResolvedStyles {
  final IconData updateIcon;
  final IconData upToDateIcon;
  final double borderRadius;
  final EdgeInsets padding;
  final double buttonBorderRadius;
  final TextStyle titleStyle;
  final TextStyle versionStyle;
  final TextStyle whatsNewStyle;
  final TextStyle contentStyle;
  final TextStyle primaryButtonTextStyle;
  final TextStyle secondaryButtonTextStyle;
  final IconData noInternetIcon;
  final bool showHandle;
  final bool showBorder;
  final double borderWidth;

  _ResolvedStyles({
    required this.updateIcon,
    required this.upToDateIcon,
    required this.borderRadius,
    required this.padding,
    required this.buttonBorderRadius,
    required this.titleStyle,
    required this.versionStyle,
    required this.whatsNewStyle,
    required this.contentStyle,
    required this.primaryButtonTextStyle,
    required this.secondaryButtonTextStyle,
    required this.noInternetIcon,
    required this.showHandle,
    required this.showBorder,
    required this.borderWidth,
  });

  factory _ResolvedStyles.resolve(
    BuildContext context,
    UpdateCheckerThemeData custom,
    _ResolvedColors colors,
  ) {
    return _ResolvedStyles(
      updateIcon: custom.updateIcon ?? Icons.system_update_alt_rounded,
      upToDateIcon: custom.upToDateIcon ?? Icons.check_circle_outline_rounded,
      borderRadius: custom.borderRadius ?? 35.0,
      padding: custom.padding ?? const EdgeInsets.fromLTRB(24, 32, 24, 32),
      buttonBorderRadius: custom.buttonBorderRadius ?? 50.0,
      titleStyle: custom.titleStyle ??
          TextStyle(
            color: colors.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
      versionStyle: custom.versionStyle ??
          TextStyle(
            color: colors.secondaryTextColor,
            fontSize: 16,
          ),
      whatsNewStyle: custom.whatsNewStyle ??
          TextStyle(
            color: colors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
      contentStyle: custom.contentStyle ??
          TextStyle(
            color: colors.textColor,
            fontSize: 14,
          ),
      primaryButtonTextStyle: custom.buttonTextStyle ??
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),
      secondaryButtonTextStyle: custom.buttonTextStyle ??
          TextStyle(
            color: colors.textColor,
          ),
      noInternetIcon: custom.noInternetIcon ?? Icons.wifi_off_rounded,
      showHandle: custom.showHandle ?? true,
      showBorder: custom.showBorder ?? false,
      borderWidth: custom.borderWidth ?? 1.0,
    );
  }
}

class _ResolvedStrings {
  final String updateAvailableTitle;
  final String upToDateTitle;
  final String versionPrefix;
  final String upToDateMessage;
  final String whatsNewLabel;
  final String notNowButton;
  final String updateNowButton;
  final String okayButton;
  final String readyToDownload;
  final String startingDownload;
  final String downloadingPrefix;
  final String installingUpdate;
  final String updateInstalled;
  final String installationFailed;
  final String checksumError;
  final String permissionDenied;
  final String internalError;
  final String downloadError;
  final String alreadyRunningError;
  final String unknownError;
  final String updateCancelled;
  final String unableToFetchTitle;
  final String noInternetMessage;

  _ResolvedStrings({
    required this.updateAvailableTitle,
    required this.upToDateTitle,
    required this.versionPrefix,
    required this.upToDateMessage,
    required this.whatsNewLabel,
    required this.notNowButton,
    required this.updateNowButton,
    required this.okayButton,
    required this.readyToDownload,
    required this.startingDownload,
    required this.downloadingPrefix,
    required this.installingUpdate,
    required this.updateInstalled,
    required this.installationFailed,
    required this.checksumError,
    required this.permissionDenied,
    required this.internalError,
    required this.downloadError,
    required this.alreadyRunningError,
    required this.unknownError,
    required this.updateCancelled,
    required this.unableToFetchTitle,
    required this.noInternetMessage,
  });

  factory _ResolvedStrings.resolve(UpdateCheckerThemeData custom) {
    return _ResolvedStrings(
      updateAvailableTitle: custom.updateAvailableTitle ?? "Update Available",
      upToDateTitle: custom.upToDateTitle ?? "Up to Date",
      versionPrefix: custom.versionPrefix ?? "Version",
      upToDateMessage: custom.upToDateMessage ?? "You are using the latest version",
      whatsNewLabel: custom.whatsNewLabel ?? "What's New:",
      notNowButton: custom.notNowButton ?? "Not Now",
      updateNowButton: custom.updateNowButton ?? "Update Now",
      okayButton: custom.okayButton ?? "Okay",
      readyToDownload: custom.readyToDownload ?? "Ready to download",
      startingDownload: custom.startingDownload ?? "Starting download...",
      downloadingPrefix: custom.downloadingPrefix ?? "Downloading",
      installingUpdate: custom.installingUpdate ?? "Installing update...",
      updateInstalled: custom.updateInstalled ?? "Update installed.",
      installationFailed: custom.installationFailed ?? "Installation failed.",
      checksumError: custom.checksumError ?? "Checksum error. Try again later.",
      permissionDenied: custom.permissionDenied ?? "Permission not granted.",
      internalError: custom.internalError ?? "An internal error occurred.",
      downloadError: custom.downloadError ?? "File could not be downloaded.",
      alreadyRunningError: custom.alreadyRunningError ?? "An update is already in progress.",
      unknownError: custom.unknownError ?? "Something went wrong.",
      updateCancelled: custom.updateCancelled ?? "Update cancelled",
      unableToFetchTitle: custom.unableToFetchTitle ?? "Unable to Fetch",
      noInternetMessage: custom.noInternetMessage ?? "Please check your internet connection and try again.",
    );
  }
}
