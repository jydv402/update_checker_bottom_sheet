import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';

void main() {
  group('UpdateCheckerThemeData Tests', () {
    test('Default values are null', () {
      const data = UpdateCheckerThemeData();
      expect(data.backgroundColor, null);
      expect(data.textColor, null);
      expect(data.updateIcon, null);
      expect(data.updateAvailableTitle, null);
    });

    test('Properties can be set', () {
      const data = UpdateCheckerThemeData(
        backgroundColor: Colors.red,
        textColor: Colors.blue,
        updateIcon: Icons.add,
        updateAvailableTitle: 'New Update',
      );
      expect(data.backgroundColor, Colors.red);
      expect(data.textColor, Colors.blue);
      expect(data.updateIcon, Icons.add);
      expect(data.updateAvailableTitle, 'New Update');
    });

    test('mergeWith merges overrides correctly', () {
      const parent = UpdateCheckerThemeData(
        backgroundColor: Colors.red,
        textColor: Colors.blue,
        updateIcon: Icons.add,
      );

      const local = UpdateCheckerThemeData(
        textColor: Colors.green,
        updateAvailableTitle: 'New Update',
      );

      final merged = parent.mergeWith(local);

      // Overridden property
      expect(merged.textColor, Colors.green);
      // Inherited property
      expect(merged.backgroundColor, Colors.red);
      expect(merged.updateIcon, Icons.add);
      // New property
      expect(merged.updateAvailableTitle, 'New Update');
    });

    test('UpdateChecker.theme assignment', () {
      expect(UpdateChecker.theme, null);

      const theme = UpdateCheckerThemeData(backgroundColor: Colors.yellow);
      UpdateChecker.theme = theme;
      expect(UpdateChecker.theme?.backgroundColor, Colors.yellow);

      // Reset
      UpdateChecker.theme = null;
    });

    test('Default update style is bottom sheet', () {
      expect(UpdateCheckerStyle.bottomSheet.index, 0);
      expect(UpdateCheckerStyle.alertDialog.index, 1);
    });
  });
}
