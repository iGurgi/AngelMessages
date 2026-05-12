import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wrap a widget with ProviderScope for testing
Widget createTestWidget(
  Widget child, {
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Pump a widget and settle all animations
Future<void> pumpWidgetWithSettle(
  WidgetTester tester,
  Widget widget, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(createTestWidget(widget, overrides: overrides));
  await tester.pumpAndSettle();
}
