import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HifzAssistantApp());
}

class HifzAssistantApp extends StatefulWidget {
  const HifzAssistantApp({super.key});

  @override
  State<HifzAssistantApp> createState() => _HifzAssistantAppState();
}

class _HifzAssistantAppState extends State<HifzAssistantApp> {
  static const _localePreferenceKey = 'preferred_language_code';

  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _restoreLocale();
  }

  Future<void> _restoreLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final savedLanguage = preferences.getString(_localePreferenceKey);
    if (!mounted || savedLanguage == null) return;

    final supportedLanguage = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == savedLanguage,
    );
    if (supportedLanguage) {
      setState(() => _locale = Locale(savedLanguage));
    }
  }

  Future<void> _changeLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.any(
      (supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode,
    )) {
      return;
    }

    setState(() => _locale = locale);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localePreferenceKey, locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).text('appName'),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F5B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F5),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: HifzHomePage(
        locale: _locale,
        onLocaleChanged: _changeLocale,
      ),
    );
  }
}

class HifzHomePage extends StatefulWidget {
  const HifzHomePage({
    required this.locale,
    required this.onLocaleChanged,
    super.key,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<HifzHomePage> createState() => _HifzHomePageState();
}

class _HifzHomePageState extends State<HifzHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final pages = [
      _HomeContent(onOpenPlanner: () => setState(() => _selectedIndex = 2)),
      _PlaceholderPage(
        title: strings.text('quran'),
        description: strings.text('comingNext'),
      ),
      _PlaceholderPage(
        title: strings.text('planner'),
        description: strings.text('comingNext'),
      ),
      _ProfileContent(
        locale: widget.locale,
        onLocaleChanged: widget.onLocaleChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.text('appName'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Text(
                widget.locale.languageCode.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: strings.text('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: strings.text('quran'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: const Icon(Icons.event_note),
            label: strings.text('planner'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: strings.text('profile'),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.onOpenPlanner});

  final VoidCallback onOpenPlanner;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF075B43), Color(0xFF0B8060)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.text('tagline'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                strings.text('welcome'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                strings.text('welcomeBody'),
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: onOpenPlanner,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF075B43),
                ),
                child: Text(strings.text('startHifz')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          strings.text('dailyPractice'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PracticeCard(
                title: strings.text('sabaq'),
                icon: Icons.add_circle_outline,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PracticeCard(
                title: strings.text('sabqi'),
                icon: Icons.replay,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PracticeCard(
                title: strings.text('manzil'),
                icon: Icons.auto_stories_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          strings.text('learningModes'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _ModeCard(
          icon: Icons.bolt,
          title: strings.text('instantMode'),
          description: strings.text('instantDescription'),
        ),
        const SizedBox(height: 10),
        _ModeCard(
          icon: Icons.check_circle_outline,
          title: strings.text('ayahMode'),
          description: strings.text('ayahDescription'),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3EE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            strings.text('foundationNote'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF315A47),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 25),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(description),
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.locale,
    required this.onLocaleChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          strings.text('language'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        RadioGroup<String>(
          groupValue: locale.languageCode,
          onChanged: (value) {
            if (value != null) {
              onLocaleChanged(Locale(value));
            }
          },
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'en',
                title: Text(strings.text('english')),
              ),
              RadioListTile<String>(
                value: 'ur',
                title: Text(strings.text('urdu')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
