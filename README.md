# Hifz Assistant

A Quran memorization companion designed to make structured Hifz accessible to learners at home and in Madaris.

## Product principles

- Quran accuracy and learner safety come before automation.
- Core Hifz and Tajweed are separate learning modules.
- Hifz learners are assumed to know Nazra; the core product focuses on memorization and revision.
- Corrections are text-first. Audio may be used when it adds value, but a human teacher does not need to send an audio correction for every mistake.
- Uncertain automated recognition must never be presented as a confirmed Quranic correction.
- Basic Hifz access is intended to remain free.
- Privacy, accessibility, Urdu/English localization, and RTL support are foundational requirements.

## Confirmed product direction

- Android-first, with iOS and web considered after the Android foundation is validated.
- Both Instant Ustaad Mode and Ayat Completion Mode.
- Complete Quran library with Indo-Pak and Uthmani script options.
- Hafs 'an Asim as the initial recitation standard; additional riwayat require separately verified data and validation.
- Hybrid AI direction: on-device capabilities plus cloud assistance, subject to device and accuracy evaluation.
- Sabaq, Sabqi, Manzil, and an adaptive personal Hifz planner.
- Individual learners and Madaris.
- A qualified human Ustaad pathway, including female-teacher choice for learners who need it.
- Tajweed Academy as a separate module.
- Urdu and English as the initial interface languages.

## Repository status

This repository is at the foundation stage. Product decisions and architecture are being documented before integrating Quran text, audio, or speech-recognition assets.

No Quran dataset, recitation model, Tajweed evaluator, or live correction engine is claimed to be implemented yet. Such components must be selected from trustworthy sources, reviewed, and tested with qualified Huffaz/Qaris before release.

## Planned layout

```text
apps/
  mobile/          Flutter Android application
backend/
  supabase/        Backend schema and functions (introduced after data design)
  ai-engine/       Quran-specific recognition and alignment services
docs/
  MASTER_BLUEPRINT.md
```

## Development rule

Do not commit unverified Quran text/audio, fabricated recognition results, mock learning progress, or claims of perfect Tajweed detection. Every feature must have explicit acceptance criteria and tests.


## Quran catalog foundation

The Android app now bundles the **Tanzil Quran Metadata v1.0** surah catalog: 114 surahs and 6,236 ayah references. It includes Arabic surah names, transliterations, English names, ayah counts, revelation type/order, ruku counts, and zero-based global ayah start indexes. The app validates the catalog totals and continuous indexes before showing it.

**Important:** this is structural metadata only. No Arabic ayah text, translation, audio, or recitation assessment is bundled or claimed to be implemented in this phase. Quran text editions (Indo-Pak and Uthmani) will be separately sourced, licensed, versioned, and reviewed before they are displayed.

Metadata attribution: **Tanzil Project — Quran Metadata v1.0**, CC BY 3.0. Source: https://tanzil.net/docs/Quran_Metadata. Original metadata download: https://tanzil.net/res/text/metadata/quran-data.xml. The copy used to bootstrap this catalog was retrieved from the public mirror myquranapp/quran-data at commit 890c49cd61a3684b4bdebba0b62b2eed78811831; the upstream source remains Tanzil Project. See the in-app Quran catalog source label and apps/mobile/assets/quran/surahs.json provenance.
