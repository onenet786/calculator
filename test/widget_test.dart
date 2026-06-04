import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator evaluates a simple expression', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.byKey(const ValueKey('button-7')));
    await tester.tap(find.byKey(const ValueKey('button-+')));
    await tester.tap(find.byKey(const ValueKey('button-8')));
    await tester.tap(find.byKey(const ValueKey('button-=')));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
  });
}
