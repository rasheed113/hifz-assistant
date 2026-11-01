# Hifz Assistant Cloudflare Worker

This Worker is the server-side proxy between the Flutter app and Quran Foundation Content APIs.

## Routes

- `GET /health` — reports Worker health and whether the required Quran Foundation credentials are configured. It never returns credentials or tokens.
- `GET /quran/chapters` — obtains a server-side OAuth2 Client Credentials token and returns the authenticated Quran Foundation chapters response.

## Cloudflare secrets

Configure these under **Worker → Settings → Variables and Secrets → Production**:

- Secret `QF_CLIENT_ID`
- Secret `QF_CLIENT_SECRET`

The Worker defaults to the `prelive` environment. To select another environment, configure a plain-text variable `QF_ENV` as `prelive` or `production`. Do not change to production until Quran Foundation has approved production access.

Never put the client secret or access token in Git, the Flutter app, logs, or a client response.

## Deploy

From this directory:

```sh
npx wrangler deploy --keep-vars
```

The `--keep-vars` option preserves runtime variables configured in the Cloudflare dashboard. The Cloudflare API token used by CI must be stored as a GitHub Actions secret named `CLOUDFLARE_API_TOKEN`; the account ID is stored as `CLOUDFLARE_ACCOUNT_ID`.

## Prelive limitation

Quran Foundation's prelive content environment contains only Al-Fatihah and Al-Baqarah. A successful chapters response verifies authentication and proxy connectivity; it does not mean the complete Quran text is available.
