import 'package:flutter/material.dart';

import '../src/theme_resolver.dart';

class HeaderSection extends StatelessWidget {
  final bool isUpToDate;
  final bool showNetworkError;
  final String latestVersion;
  final ResolvedColors colors;
  final ResolvedStyles styles;
  final ResolvedStrings strings;

  const HeaderSection({
    super.key,
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
