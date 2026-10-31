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
