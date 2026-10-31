# Hifz Assistant — Master Engineering Blueprint v1.0

## 1. Mission

Make Quran memorization more accessible to people who want to memorize but cannot regularly attend a Madrasa, while also supporting Madaris and qualified teachers.

The product is an assistant for Hifz, not a replacement for the Quran, a qualified Qari, or a human teacher.

## 2. Confirmed product decisions

| Area | Decision |
|---|---|
| Initial platform | Android first; iOS and web later |
| Audience | Individual learners and Madaris |
| Accessibility | Learners studying at home, including people with family or work responsibilities |
| Core learning | Hifz for learners who already know Nazra |
| Recitation modes | Instant Ustaad Mode and Ayat Completion Mode |
| Quran library | Complete Quran reference |
| Initial riwayah | Hafs 'an Asim |
| Quran scripts | Indo-Pak and Uthmani |
| Initial UI languages | Urdu and English |
| Architecture direction | Hybrid on-device and cloud AI, subject to feasibility tests |
| Hifz curriculum | Sabaq, Sabqi, Manzil |
| Planning | Adaptive personal Hifz planner |
| Human support | Qualified Ustaad system; text-first corrections, audio optional |
| Tajweed | Separate learning module and progress tracking |
| Basic access | Core Hifz features intended to remain permanently free |
| Sustainability | Optional premium capabilities and transparent sponsorship/donations |

## 3. Learning model

### Hifz Academy

- Sabaq: new memorization.
- Sabqi: recent memorization revision.
- Manzil: revision of older memorized portions.
- Instant Ustaad Mode: pause on a sufficiently confident, verified mismatch and show the relevant correct Quran text.
- Ayat Completion Mode: assess the recitation after an ayah boundary.
- Correction display: text-first. Human audio correction is optional.
- Planner: adapt workload to learner availability and demonstrated retention; never pressure a learner to meet an unrealistic deadline.

### Tajweed Academy

A separate module with separate progress. It may include lessons and practice for makharij, sifaat, and rules of Tajweed. Automated assessment must be validated by qualified Qaris; no claim of complete or perfect Tajweed detection is permitted without evidence.

## 4. Accuracy and safety requirements

1. Quran text must come from a trusted, licensed, versioned source and be reviewed before release.
2. Every ayah needs a stable canonical identifier independent of display script.
3. Indo-Pak and Uthmani renderings must map to the same canonical ayah and word references where the source supports that mapping.
4. The initial recitation profile is Hafs 'an Asim. Do not mix text, audio, or rules from different riwayat.
5. Speech recognition must be Quran-specific or demonstrably suitable for Quran recitation. Generic dictation transcription is not sufficient as the sole verifier.
6. The verifier must align recitation to expected ayah/word sequence and represent uncertainty.
7. Do not trigger a punitive red alert on uncertain audio, silence, background noise, or microphone failure. Ask the learner to repeat or mark the segment as uncertain.
8. A confirmed mismatch should show the expected Quran text and the location of the mismatch. Do not invent a correction.
9. Tajweed evaluation is separate from Hifz word/sequence checking.
10. Qualified Huffaz and Qaris must participate in test design and acceptance review.

## 5. Proposed technical architecture

This is a proposed architecture, not a claim that all services are already implemented.

### Android client

- Flutter and Dart.
- Localized UI: Urdu and English first.
- RTL/LTR layout support.
- Offline-capable Quran reading and cached learner plan, after verified content packaging.
- Audio capture with explicit microphone permission and visible recording state.
- Local encrypted storage for sensitive learner data.
- No recording upload by default without clear user consent.

### Backend

Supabase is a candidate for authentication, PostgreSQL data, storage metadata, and secure application APIs. Final schema and row-level security policies must be designed before production use.

### AI services

- On-device: audio pre-processing, lightweight inference or alignment where model quality and Android device constraints permit.
- Cloud: heavier inference, detailed analysis, and optional teacher workflows.
- Both paths must use the same versioned Quran reference and confidence policy.
- Model selection requires a benchmark across accents, recitation pace, phones, microphones, and noisy/quiet environments.

### Teacher and Madrasa portal

A web portal can be introduced after the learner workflow and permissions are defined. It will support verified teacher profiles, student-teacher relationships, assignments, text feedback, and consent-based audio submissions.

## 6. Core data domains (design only)

- Quran source/version, riwayah, script edition, surah, ayah, and word references.
- User profile, interface language, script preference, and privacy settings.
- Hifz enrollment, memorization status, Sabaq/Sabqi/Manzil assignments.
- Recitation attempt metadata, recognized segments, confidence, and review outcome.
- Planner preferences, availability, and revision schedule.
- Teacher credentials/verification, learner-teacher consent, feedback, and session records.
- Separate Tajweed curriculum and assessment records.
- Sponsorship and donation ledger with transparent reporting.

Do not implement database migrations until Quran identifiers, source licensing, privacy requirements, and access-control rules have been reviewed.

## 7. Privacy and safeguarding

- Ask for microphone permission only when the learner starts a recitation feature.
- Explain whether audio stays on-device or is sent to cloud services.
- Obtain explicit consent before cloud upload or teacher sharing.
- Provide deletion/export paths for learner recordings and account data.
- Restrict teacher access to explicitly connected students.
- Apply extra safeguarding and consent rules for minors.
- Never expose private student recitations or progress publicly by default.

## 8. Development phases

### Phase 0 — Repository foundation
- Establish project documentation and Flutter source layout.
- Confirm build environment and supported Android baseline.
- Add CI for formatting, analysis, and tests.

### Phase 1 — Verified Quran reference
- Evaluate source provenance, licensing, text editions, audio sources, and canonical identifiers.
- Build automated integrity checks and scholar review workflow.
- No live AI correction until the reference corpus is approved.

### Phase 2 — Learner foundation
- Onboarding, language/script preferences, local profile, and Hifz plan setup.
- Sabaq, Sabqi, Manzil tracking with explicit learner actions.
- Offline behavior and data synchronization rules.

### Phase 3 — Recitation proof of concept
- Collect consented, representative test recordings.
- Benchmark candidate Quran speech recognition/alignment models.
- Measure false alerts, missed errors, latency, and uncertainty handling.
- Run expert-reviewed acceptance tests before learner-facing release.

### Phase 4 — Hifz assistant modes
- Implement Instant Ustaad and Ayat Completion workflows.
- Text-first correction and repeat flow.
- Add transparent confidence/uncertainty handling.

### Phase 5 — Adaptive planner
- Build a transparent, adjustable schedule using learner retention and availability.
- Allow learners to override recommendations.

### Phase 6 — Human teachers and Madaris
- Teacher verification, student consent, assignments, feedback, and institution roles.
- Add teacher portal after security review.

### Phase 7 — Tajweed Academy
- Separate content, progress, and validated assessment.
- Qualified Qari review for every automated evaluation feature.

### Phase 8 — Expansion
- iOS and web clients.
- Additional languages.
- Additional riwayat only with separate verified corpora and expert validation.

## 9. Definition of done

A feature is not complete because a screen exists. It must include:
- Real data flow and persistence where required.
- Loading, empty, error, offline, and permission-denied states.
- Accessibility and Urdu RTL checks.
- Unit/widget/integration tests appropriate to the feature.
- Security and privacy review for personal or audio data.
- Documented acceptance criteria.
- No fake Quran text, fake recitation results, or fabricated progress.

## 10. Current implementation status

The Flutter foundation includes a bundled, source-attributed Tanzil Quran Metadata v1.0 catalog with 114 surahs and 6,236 ayah references, an integrity-validating repository, and an English/Urdu searchable Surah index. This is structural metadata only: no Quran ayah text, translation, audio, authentication, backend schema, speech recognition, live correction, or planner logic is implemented yet. Quran text editions remain a separate release gate pending source/script review and qualified verification.
