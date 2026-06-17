import 'package:flutter/material.dart';

import '../src/theme_resolver.dart';

class ActionsSection extends StatelessWidget {
  final bool isUpToDate;
  final VoidCallback onUpdate;
  final ResolvedColors colors;
  final ResolvedStyles styles;
  final ResolvedStrings strings;

  const ActionsSection({
    super.key,
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
          child: Text(strings.okayButton, style: styles.primaryButtonTextStyle),
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
