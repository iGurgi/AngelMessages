import 'package:flutter_test/flutter_test.dart';
import 'package:angel_messages/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AngelMessagesApp());

    // Verify that the app renders
    expect(find.byType(AngelMessagesApp), findsOneWidget);
  });
}
