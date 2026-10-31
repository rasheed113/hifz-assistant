import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../data/quran_catalog_repository.dart';
import '../data/quran_surah.dart';

class QuranLibraryPage extends StatefulWidget {
  const QuranLibraryPage({super.key});

  @override
  State<QuranLibraryPage> createState() => _QuranLibraryPageState();
}

class _QuranLibraryPageState extends State<QuranLibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<QuranSurah>> _surahsFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _surahsFuture = QuranCatalogRepository().loadSurahs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _query = _searchController.text.trim().toLowerCase());
  }

  void _retryLoad() {
    setState(() {
      _surahsFuture = QuranCatalogRepository().loadSurahs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return FutureBuilder<List<QuranSurah>>(
      future: _surahsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _LoadError(
            message: strings.text('quranLoadError'),
            onRetry: _retryLoad,
          );
        }

        final surahs = snapshot.data ?? const <QuranSurah>[];
        final filteredSurahs = surahs.where((surah) {
          return surah.number.toString().contains(_query) ||
              surah.nameArabic.contains(_query) ||
              surah.transliteration.toLowerCase().contains(_query) ||
              surah.englishName.toLowerCase().contains(_query);
        }).toList(growable: false);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: strings.text('searchSurahs'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: strings.text('clearSearch'),
                          onPressed: _searchController.clear,
                          icon: const Icon(Icons.close),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Text(
                    strings.text('surahCount').replaceAll(
                      '{count}',
                      filteredSurahs.length.toString(),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    strings.text('quranDataSource'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredSurahs.isEmpty
                  ? Center(child: Text(strings.text('noSurahsFound')))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filteredSurahs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final surah = filteredSurahs[index];
                        return _SurahTile(
                          surah: surah,
                          onTap: () => _showSurahDetails(context, surah),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showSurahDetails(BuildContext context, QuranSurah surah) {
    final strings = AppLocalizations.of(context);
    final isMeccan = surah.revelationType == 'meccan';

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  surah.nameArabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${surah.number}. ${surah.transliteration}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                _DetailRow(
                  label: strings.text('ayahCount'),
                  value: surah.ayahCount.toString(),
                ),
                _DetailRow(
                  label: strings.text('revelationPlace'),
                  value: strings.text(isMeccan ? 'meccan' : 'medinan'),
                ),
                _DetailRow(
                  label: strings.text('rukuCount'),
                  value: surah.rukuCount.toString(),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.text('ayahTextComingAfterVerification'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.surah, required this.onTap});

  final QuranSurah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isMeccan = surah.revelationType == 'meccan';

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            surah.number.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                surah.transliteration,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              surah.nameArabic,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 19),
            ),
          ],
        ),
        subtitle: Text(
          '${surah.englishName} • ${surah.ayahCount} ${strings.text('ayahs')} • '
          '${strings.text(isMeccan ? 'meccan' : 'medinan')}',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).text('retry')),
            ),
          ],
        ),
      ),
    );
  }
}
