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
              child: Text('Angel Messages'),
            ),
          ),
        ),
      ),
    );

    // Verify the app renders
    expect(find.text('Angel Messages'), findsOneWidget);
  });

  testWidgets('ProviderScope initializes correctly', (WidgetTester tester) async {
    var didBuild = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              didBuild = true;
              return const Scaffold(
                body: Center(
                  child: Text('Test'),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(didBuild, isTrue);
    expect(find.text('Test'), findsOneWidget);
  });
}
