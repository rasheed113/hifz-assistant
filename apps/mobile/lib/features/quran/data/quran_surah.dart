class QuranSurah {
  const QuranSurah({
    required this.number,
    required this.nameArabic,
    required this.transliteration,
    required this.englishName,
    required this.ayahCount,
    required this.globalStartIndex,
    required this.revelationType,
    required this.revelationOrder,
    required this.rukuCount,
  });

  final int number;
  final String nameArabic;
  final String transliteration;
  final String englishName;
  final int ayahCount;

  /// Zero-based position of this surah's first ayah in the Quran.
  final int globalStartIndex;

  final String revelationType;
  final int revelationOrder;
  final int rukuCount;

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      transliteration: json['transliteration'] as String,
      englishName: json['englishName'] as String,
      ayahCount: json['ayahCount'] as int,
      globalStartIndex: json['globalStartIndex'] as int,
      revelationType: json['revelationType'] as String,
      revelationOrder: json['revelationOrder'] as int,
      rukuCount: json['rukuCount'] as int,
    );
  }
}
