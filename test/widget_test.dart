import 'package:flutter_test/flutter_test.dart';
import 'package:angel_messages/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without crashing
    expect(find.text('Angel Messages'), findsWidgets);
  });
}
