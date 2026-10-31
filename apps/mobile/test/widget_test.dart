import 'package:flutter_test/flutter_test.dart';
import 'package:hifz_assistant/main.dart';

void main() {
  testWidgets('shows the Hifz home screen in English', (tester) async {
    await tester.pumpWidget(const HifzAssistantApp());

    expect(find.text('Hifz Assistant'), findsOneWidget);
    expect(find.text('Your Hifz journey starts here'), findsOneWidget);
    expect(find.text('Sabaq'), findsOneWidget);
  });

  testWidgets('allows switching the interface to Urdu', (tester) async {
    await tester.pumpWidget(const HifzAssistantApp());

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Urdu'));
    await tester.pumpAndSettle();

    expect(find.text('حفظ اسسٹنٹ'), findsOneWidget);
    expect(find.text('آپ کا حفظ کا سفر یہاں سے شروع ہوتا ہے'), findsOneWidget);
  });
}
