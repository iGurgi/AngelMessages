import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:angel_messages/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AngelMessagesApp(),
      ),
    );

    // Verify that the app starts without throwing errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Onboarding page shows welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AngelMessagesApp(),
      ),
    );

    // Wait for initial route to load
    await tester.pumpAndSettle();

    // Verify onboarding content is shown
    expect(find.text('Welcome to Angel Messages'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
