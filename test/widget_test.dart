import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator evaluates a simple expression', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('Rainbow Calculator'), findsOneWidget);
    expect(find.text('Powered by OneNet Solutions Pakistan'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('button-7')));
    await tester.tap(find.byKey(const ValueKey('button-+')));
    await tester.tap(find.byKey(const ValueKey('button-8')));
    await tester.tap(find.byKey(const ValueKey('button-=')));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
  });
}
