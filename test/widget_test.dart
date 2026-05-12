import 'package:flutter_test/flutter_test.dart';
import 'package:angel_messages/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app loads
    expect(find.text('Angel Messages'), findsOneWidget);
  });
}
