import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    final markdownStyle = MarkdownStyleSheet.fromTheme(Theme.of(context))
        .copyWith(
          p: styles.contentStyle,
          h1: styles.whatsNewStyle,
          h2: styles.whatsNewStyle,
          h3: styles.whatsNewStyle,
          listBullet: styles.contentStyle,
          listBulletPadding: const EdgeInsets.only(left: 8),
          blockSpacing: 8,
          code: styles.contentStyle.copyWith(
            fontFamily: 'monospace',
            backgroundColor: colors.pillColor,
          ),
          codeblockPadding: const EdgeInsets.all(12),
          codeblockDecoration: BoxDecoration(
            color: colors.pillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          a: styles.contentStyle.copyWith(color: colors.accentColor),
        );

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
            child: MarkdownBody(
              data: releaseNotes,
              styleSheet: markdownStyle,
              softLineBreak: true,
            ),
          ),
        ),
      ],
    );
  }
}
