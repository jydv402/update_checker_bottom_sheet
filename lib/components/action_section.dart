import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../src/theme_resolver.dart';

class ActionsSection extends StatelessWidget {
  final bool isUpToDate;
  final VoidCallback onUpdate;
  final bool enableHaptics;
  final bool showRedirectButton;
  final String githubRepo;
  final ResolvedColors colors;
  final ResolvedStyles styles;
  final ResolvedStrings strings;

  const ActionsSection({
    super.key,
    required this.isUpToDate,
    required this.onUpdate,
    this.enableHaptics = false,
    this.showRedirectButton = false,
    required this.githubRepo,
    required this.colors,
    required this.styles,
    required this.strings,
  });

  void _triggerImpact() {
    if (enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _openRepository() async {
    final uri = Uri.parse('https://github.com/$githubRepo/releases/latest');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColumn = <Widget>[];

    if (showRedirectButton) {
      buttonColumn.add(
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _triggerImpact();
              _openRepository();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(18),
              side: BorderSide(color: colors.textColor.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(styles.buttonBorderRadius),
              ),
            ),
            child: Text(
              strings.redirectButton,
              style: styles.secondaryButtonTextStyle,
            ),
          ),
        ),
      );
      buttonColumn.add(const SizedBox(height: 12));
    }

    if (isUpToDate) {
      return Column(
        children: [
          ...buttonColumn,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _triggerImpact();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentColor,
                foregroundColor: colors.accentTextColor,
                padding: const EdgeInsets.all(18),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    styles.buttonBorderRadius,
                  ),
                ),
              ),
              child: Text(
                strings.okayButton,
                style: styles.primaryButtonTextStyle,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        ...buttonColumn,
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _triggerImpact();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  side: BorderSide(
                    color: colors.textColor.withValues(alpha: 0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      styles.buttonBorderRadius,
                    ),
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
                onPressed: () {
                  _triggerImpact();
                  onUpdate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accentColor,
                  foregroundColor: colors.accentTextColor,
                  padding: const EdgeInsets.all(18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      styles.buttonBorderRadius,
                    ),
                  ),
                ),
                child: Text(
                  strings.updateNowButton,
                  style: styles.primaryButtonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
