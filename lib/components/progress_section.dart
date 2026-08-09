import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/theme_resolver.dart';

class ProgressSection extends StatelessWidget {
  final double progress;
  final String statusMessage;
  final VoidCallback onCancel;
  final bool enableHaptics;
  final ResolvedColors colors;
  final ResolvedStyles styles;

  const ProgressSection({
    super.key,
    required this.progress,
    required this.statusMessage,
    required this.onCancel,
    this.enableHaptics = false,
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
            Expanded(child: Text(statusMessage, style: styles.contentStyle)),
            TextButton(
              onPressed: () {
                if (enableHaptics) {
                  HapticFeedback.lightImpact();
                }
                onCancel();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    );
  }
}
