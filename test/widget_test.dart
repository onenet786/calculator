import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator evaluates a simple expression', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('Rainbow Calculator'), findsOneWidget);
    expect(find.text('Powered by OneNet Solutions Pakistan'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4600));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('button-7')));
    await tester.tap(find.byKey(const ValueKey('button-+')));
    await tester.tap(find.byKey(const ValueKey('button-8')));
    await tester.tap(find.byKey(const ValueKey('button-=')));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('calculator buttons use contrast colors instead of black', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pump(const Duration(milliseconds: 4600));
    await tester.pumpAndSettle();

    // Verify '7' button has a contrast foreground color (its spec color) and not black/slate
    final finder7 = find.byKey(const ValueKey('button-7'));
    final badge7 = tester.widget(
      find.descendant(
        of: finder7,
        matching: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_PictureBadge',
        ),
      ),
    );

    // Access the foreground property via dynamic since _PictureBadge is private
    final dynamic badgeWidget = badge7;
    expect(
      badgeWidget.foreground,
      const Color(0xFFFF9671),
    ); // spec color for '7'
    expect(
      badgeWidget.foreground,
      isNot(const Color(0xFF243B53)),
    ); // not the old black slate
  });

  testWidgets(
    'speech language toggling, repeat answer, and history playback flow works without error',
    (tester) async {
      await tester.pumpWidget(const CalculatorApp());
      await tester.pump(const Duration(milliseconds: 4600));
      await tester.pumpAndSettle();

      // Initially Urdu is active (UR is shown)
      expect(find.text('UR'), findsOneWidget);
      expect(find.text('EN'), findsNothing);

      // Toggle language to English (tap UR)
      await tester.tap(find.text('UR'));
      await tester.pumpAndSettle();

      // Now English is active (EN is shown)
      expect(find.text('EN'), findsOneWidget);
      expect(find.text('UR'), findsNothing);

      // Perform a calculation: 9 - 3 = 6
      await tester.tap(find.byKey(const ValueKey('button-9')));
      await tester.tap(find.byKey(const ValueKey('button--')));
      await tester.tap(find.byKey(const ValueKey('button-3')));
      await tester.tap(find.byKey(const ValueKey('button-=')));
      await tester.pumpAndSettle();

      // Verify the display is '6'
      final display6Finder = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_DisplayPanel',
        ),
        matching: find.text('6'),
      );
      expect(display6Finder, findsOneWidget);

      // Repeat last answer should work without errors
      await tester.tap(find.byKey(const ValueKey('repeat-answer')));
      await tester.pumpAndSettle();

      // Toggle back to Urdu (tap EN)
      await tester.tap(find.text('EN'));
      await tester.pumpAndSettle();
      expect(find.text('UR'), findsOneWidget);

      // History record should have been created. Replaying it should work without error
      final repeatHistoryFinder = find.byKey(
        const ValueKey('repeat-history-0'),
      );
      expect(repeatHistoryFinder, findsOneWidget);
      await tester.tap(repeatHistoryFinder, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Clear history should work
      final clearHistoryFinder = find.byKey(const ValueKey('clear-history'));
      expect(clearHistoryFinder, findsOneWidget);
      await tester.tap(clearHistoryFinder);
      await tester.pumpAndSettle();

      expect(find.text('History will appear here'), findsOneWidget);
    },
  );

  testWidgets('cap icon opens learning drawer with tables and counting', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pump(const Duration(milliseconds: 4600));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('learning-menu-button')));
    await tester.pumpAndSettle();

    expect(find.text('Learning Menu'), findsOneWidget);
    expect(find.text('Button Info'), findsNothing);
    expect(find.text('Tables'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('table-2')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('2 × 10 = 20'), findsOneWidget);
    expect(find.byKey(const ValueKey('stop-learning-speech')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('stop-learning-speech')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('stop-learning-speech')), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('counting-row-25')),
      260,
      scrollable: find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Counting 1-100'), findsOneWidget);
    expect(find.text('twenty five'), findsOneWidget);

    final countingHeader = find.byKey(
      const ValueKey('drawer-section-Counting 1-100'),
    );
    await tester.ensureVisible(countingHeader);
    await tester.pumpAndSettle();
    await tester.tap(countingHeader);
    await tester.pump(const Duration(seconds: 9));
    await tester.pumpAndSettle();
    expect(find.text('گنتی جاری رکھنا چاہتے ہیں؟'), findsOneWidget);
    expect(find.text('ہاں'), findsOneWidget);
    expect(find.text('نہیں'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cancel-counting')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('close-learning-menu')));
    await tester.pumpAndSettle();

    expect(find.text('Rainbow Calculator'), findsOneWidget);
    expect(find.text('Learning Menu'), findsNothing);
  });
}
