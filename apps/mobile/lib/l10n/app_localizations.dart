import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Initial app strings for English and Urdu.
///
/// Keep Quranic Arabic text out of this translation map. Quran text must come
/// from a separately verified Quran data source, never from UI translations.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  static AppLocalizations of(BuildContext context) {
    final result =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(result != null, 'AppLocalizations delegate is missing.');
    return result!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'appName': 'Hifz Assistant',
      'tagline': 'Your companion for Quran memorization',
      'home': 'Home',
      'quran': 'Quran',
      'planner': 'My plan',
      'profile': 'Profile',
      'welcome': 'Your Hifz journey starts here',
      'welcomeBody':
          'Build a steady memorization routine with Sabaq, Sabqi and Manzil.',
      'startHifz': 'Set up my Hifz plan',
      'dailyPractice': 'Daily practice',
      'sabaq': 'Sabaq',
      'sabqi': 'Sabqi',
      'manzil': 'Manzil',
      'learningModes': 'Recitation modes',
      'instantMode': 'Instant Ustaad Mode',
      'instantDescription':
          'Pause and review when a likely mistake is detected.',
      'ayahMode': 'Ayat Completion Mode',
      'ayahDescription': 'Review the recitation after completing an ayah.',
      'comingNext': 'Coming in a later development phase',
      'foundationNote':
          'This is the app foundation. Quran data and live recitation checking will be added only after source verification and accuracy testing.',
      'language': 'Language',
      'english': 'English',
      'urdu': 'Urdu',
    },
    'ur': {
      'appName': 'حفظ اسسٹنٹ',
      'tagline': 'قرآن حفظ کرنے میں آپ کا ساتھی',
      'home': 'ہوم',
      'quran': 'قرآن',
      'planner': 'میرا منصوبہ',
      'profile': 'پروفائل',
      'welcome': 'آپ کا حفظ کا سفر یہاں سے شروع ہوتا ہے',
      'welcomeBody':
          'سبق، سبقی اور منزل کے ساتھ حفظ کا مستقل معمول بنائیں۔',
      'startHifz': 'اپنا حفظ پلان بنائیں',
      'dailyPractice': 'روزانہ کی مشق',
      'sabaq': 'سبق',
      'sabqi': 'سبقی',
      'manzil': 'منزل',
      'learningModes': 'تلاوت کے طریقے',
      'instantMode': 'فوری استاد موڈ',
      'instantDescription': 'ممکنہ غلطی پر تلاوت روک کر جائزہ لیں۔',
      'ayahMode': 'آیت مکمل ہونے پر جائزہ',
      'ayahDescription': 'آیت مکمل ہونے کے بعد تلاوت کا جائزہ لیں۔',
      'comingNext': 'اگلے ترقیاتی مرحلے میں شامل ہوگا',
      'foundationNote':
          'یہ ابتدائی ایپ بنیاد ہے۔ قرآن کا متن اور براہِ راست تلاوت کی جانچ مستند ذرائع اور درستگی کی جانچ کے بعد شامل ہوگی۔',
      'language': 'زبان',
      'english': 'انگریزی',
      'urdu': 'اردو',
    },
  };

  String text(String key) {
    final languageValues = _values[locale.languageCode] ?? _values['en']!;
    return languageValues[key] ?? _values['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
        (supported) => supported.languageCode == locale.languageCode,
      );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
