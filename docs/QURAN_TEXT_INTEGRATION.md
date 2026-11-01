# Indo-Pak Quran Text Integration

**Status:** Indo-Pak source decision accepted. A Cloudflare Worker prelive Content API proxy is now implemented; full Quran Content Sync and production content remain gated on the required access and validation.

## Decision

- Initial recitation: Hafs 'an Asim.
- First Arabic edition: Indo-Pak Nastaleeq.
- Keep the existing Tanzil surah catalog as structural metadata; it is not the source of the Indo-Pak ayah text.
- Use Quran Foundation's canonical `quran_core:1` Content Sync resource for Quran text and word records.
- Do not bundle Indo-Pak text copied from an unlicensed mirror, scrape a third-party app, or treat a font change as a conversion from Uthmani to Indo-Pak.
- Do not ship text until source identity, data integrity, rendering, and qualified review have passed.

## Authoritative integration reference

Quran Foundation Content Sync documentation:

- Getting started: https://api-docs.quran.com/docs/tutorials/content-sync/getting-started/
- Client flow: https://api-docs.quran.com/docs/tutorials/content-sync/client-flow/
- FAQ and content/storage terms: https://api-docs.quran.com/docs/tutorials/faq/
- Developer Console: https://dev-console.quran.foundation/

The documented `quran_core:1` snapshot contains canonical Quran records, including 114 chapters, 6,236 verses, and word-level records. Word records expose `text_indopak_nastaleeq`, `text_indopak`, `text_uthmani_tajweed`, and `text_imlaei`. Use `text_indopak_nastaleeq` for the Indo-Pak Nastaleeq edition and pair it with the compatible font `indopak-nastaleeq-waqf-lazim-v4.2.1`. The older `text_indopak` field is documented as deprecated.

## Access and environment gate

- Content API prelive base: `https://apis-prelive.quran.foundation/content/api/v4`; production base: `https://apis.quran.foundation/content/api/v4`.
- Prelive contains only Al-Fatihah and Al-Baqarah. It cannot validate a complete 114-surah Quran release.
- Production access must be approved in the Quran Foundation Developer Console before switching environments.
- Content APIs use OAuth2 Client Credentials with `scope=content` from a **Backend/server app**. The token endpoint is `/oauth2/token` on the matching environment's OAuth host.
- Authenticated Content API calls require both `x-auth-token` and `x-client-id`.
- Hifz Assistant's Cloudflare Worker stores `QF_CLIENT_ID` and `QF_CLIENT_SECRET` as Cloudflare secrets and proxies `GET /quran/chapters`. The Worker defaults to `QF_ENV=prelive`.
- The Flutter app must call the Worker; it must never receive the client secret or make the confidential token request itself.
- Never commit secrets or access tokens, or write them to logs, crash reports, or analytics.

The current Worker implements the first authenticated Content API request only. It does **not** implement Content Sync, download Quran text, or make the complete Quran available. Do not substitute demo credentials or silently fall back to an unlicensed bundled dataset.

## Content Sync requirements

Track `quran_core:1` only for the first Arabic-text milestone.

1. Bootstrap Content Sync and follow every `next_page_url` until the final page.
2. Fetch every snapshot URL returned by resource creation/invalidation.
3. Store the complete local snapshot before persisting the final `next_sync_token`.
4. Apply row mutations using the documented resource group, resource ID, record type, and record key.
5. Replace the resource on invalidation; remove it if the resource is deleted.
6. Persist a sync token only after all pages and snapshots are successfully applied.
7. Sync at least every seven days when connectivity permits. Previously synced content may remain available through a connectivity outage; sync promptly when connectivity returns.
8. If the resource is available through Content Sync, do not build the offline copy from ordinary Content API responses.

The local store must support an atomic update strategy so an interrupted sync cannot leave the reader with a partially replaced Quran corpus.

## Rendering requirements

- Render the Indo-Pak text with its compatible Quran Foundation font; a generic Arabic font is not an acceptable substitute.
- Preserve the source-provided word order and word boundaries. Do not split words heuristically to derive word-level data.
- Keep stable canonical verse identifiers independent of script.
- Keep surah and ayah numbering aligned with the existing 114/6,236 catalog.
- Show the required attribution wherever Quranic content is displayed: **“Quran data provided by Quran.Foundation.”**
- Do not transform, normalize, autocorrect, or manually edit Quran text. Any display-only shaping must be tested against the original source data.

## Validation and release gates

Automated checks must cover:

- Exactly 114 chapter records and 6,236 verse records.
- Expected Hafs verse keys and per-surah ayah counts matching the existing catalog.
- Complete, non-duplicated word references with stable verse/position mapping.
- Presence of the selected Indo-Pak Nastaleeq field on the expected word rows.
- Font availability and representative glyph/rendering checks, including waqf marks and ayah markers.
- Sync bootstrap pagination, incremental updates, invalidation, deletion, interrupted sync, and seven-day refresh behavior.
- Urdu RTL layout, long ayahs, small Android screens, and offline reading after a completed sync.

A qualified Hafiz/Qari review is required before public release. Automated structural checks do not establish scholarly correctness.

## Explicitly out of scope

This milestone does not add translations, tafsir, recitation audio, speech recognition, automated correction, Tajweed assessment, or additional riwayat. Uthmani can be added as a separately validated edition after Indo-Pak is stable.
