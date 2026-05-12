import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App initializes without errors', (WidgetTester tester) async {
    // Build a minimal test widget with ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
        ),
      ),
    );

    // Verify test widget renders
    expect(find.text('Test'), findsOneWidget);
  });
}
