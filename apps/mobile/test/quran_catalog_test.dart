import 'package:flutter_test/flutter_test.dart';
import 'package:hifz_assistant/features/quran/data/quran_catalog_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the complete 114-surah catalog with 6,236 ayah references',
      () async {
    final surahs = await QuranCatalogRepository().loadSurahs();

    expect(surahs, hasLength(QuranCatalogRepository.expectedSurahCount));
    expect(
      surahs.fold<int>(0, (total, surah) => total + surah.ayahCount),
      QuranCatalogRepository.expectedAyahCount,
    );
    expect(surahs.first.nameArabic, 'الفاتحة');
    expect(surahs.first.ayahCount, 7);
    expect(surahs.last.number, 114);
    expect(surahs.last.englishName, 'Mankind');
  });

  test('surah global start indexes are continuous and zero based', () async {
    final surahs = await QuranCatalogRepository().loadSurahs();
    var nextExpectedIndex = 0;

    for (final surah in surahs) {
      expect(surah.globalStartIndex, nextExpectedIndex);
      nextExpectedIndex += surah.ayahCount;
    }

    expect(nextExpectedIndex, 6236);
  });
}
