import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hifz_assistant/features/quran/presentation/quran_library_page.dart';

void main() {
  testWidgets('shows real surah metadata and supports search', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: QuranLibraryPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Al-Faatiha'), findsOneWidget);
    expect(find.text('The Opening • 7 ayahs • Meccan'), findsOneWidget);
    expect(find.text('Al-Baqara'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '114');
    await tester.pumpAndSettle();

    expect(find.text('An-Naas'), findsOneWidget);
    expect(find.text('Al-Faatiha'), findsNothing);
  });
}
