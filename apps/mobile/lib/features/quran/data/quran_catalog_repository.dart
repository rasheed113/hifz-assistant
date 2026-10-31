import 'dart:convert';

import 'package:flutter/services.dart';

import 'quran_surah.dart';

class QuranCatalogRepository {
  QuranCatalogRepository({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  static const assetPath = 'assets/quran/surahs.json';
  static const expectedSurahCount = 114;
  static const expectedAyahCount = 6236;

  final AssetBundle _assetBundle;

  Future<List<QuranSurah>> loadSurahs() async {
    final source = await _assetBundle.loadString(assetPath);
    final document = jsonDecode(source) as Map<String, dynamic>;
    final metadata = document['metadata'] as Map<String, dynamic>;
    if (metadata['source'] != 'Tanzil Project' ||
        metadata['version'] != '1.0') {
      throw const FormatException(
        'Unexpected Quran metadata source or version.',
      );
    }
    final rawSurahs = document['surahs'] as List<dynamic>;
    final surahs = rawSurahs
        .map(
          (item) => QuranSurah.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);

    _validateCatalog(surahs);
    return surahs;
  }

  static void _validateCatalog(List<QuranSurah> surahs) {
    if (surahs.length != expectedSurahCount) {
      throw const FormatException('Quran catalog must contain 114 surahs.');
    }

    var expectedStartIndex = 0;
    for (var index = 0; index < surahs.length; index++) {
      final surah = surahs[index];
      if (surah.number != index + 1 ||
          surah.ayahCount <= 0 ||
          surah.globalStartIndex != expectedStartIndex ||
          surah.nameArabic.isEmpty ||
          surah.transliteration.isEmpty ||
          surah.englishName.isEmpty) {
        throw FormatException(
          'Quran catalog integrity check failed at surah ${index + 1}.',
        );
      }
      expectedStartIndex += surah.ayahCount;
    }

    if (expectedStartIndex != expectedAyahCount) {
      throw const FormatException(
        'Quran catalog must contain 6,236 ayahs in total.',
      );
    }
  }
}
