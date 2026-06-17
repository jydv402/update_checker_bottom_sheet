import 'package:flutter/material.dart';

import '../src/theme_resolver.dart';

class ReleaseNotesSection extends StatelessWidget {
  final String releaseNotes;
  final ResolvedColors colors;
  final ResolvedStyles styles;
  final ResolvedStrings strings;

  const ReleaseNotesSection({
    super.key,
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
        Text(strings.whatsNewLabel, style: styles.whatsNewStyle),
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
            child: Text(releaseNotes, style: styles.contentStyle),
          ),
        ),
      ],
    );
  }
}
