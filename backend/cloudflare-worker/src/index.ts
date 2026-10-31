interface Env {
  QF_CLIENT_ID?: string;
  QF_CLIENT_SECRET?: string;
  QF_ENV?: string;
}

interface CachedToken {
  value: string;
  expiresAt: number;
}

let cachedToken: CachedToken | undefined;
let tokenRequest: Promise<string> | undefined;

const ENVIRONMENTS = {
  prelive: {
    auth: "https://prelive-oauth2.quran.foundation",
    api: "https://apis-prelive.quran.foundation",
  },
  production: {
    auth: "https://oauth2.quran.foundation",
    api: "https://apis.quran.foundation",
  },
} as const;

type QuranEnvironment = keyof typeof ENVIRONMENTS;

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
      "access-control-allow-origin": "*",
      "access-control-allow-methods": "GET, OPTIONS",
      "access-control-allow-headers": "content-type",
      "x-content-type-options": "nosniff",
    },
  });
}

function getConfiguration(env: Env) {
  const clientId = env.QF_CLIENT_ID?.trim();
  const clientSecret = env.QF_CLIENT_SECRET;
  const selectedEnvironment = (env.QF_ENV?.trim() || "prelive") as QuranEnvironment;

  if (!clientId || !clientSecret) {
    return { error: "quran_foundation_credentials_missing" as const };
  }

  if (!(selectedEnvironment in ENVIRONMENTS)) {
    return { error: "quran_foundation_environment_invalid" as const };
  }

  return {
    clientId,
    clientSecret,
    environment: selectedEnvironment,
    urls: ENVIRONMENTS[selectedEnvironment],
  };
}

async function requestAccessToken(env: Env, forceRefresh = false): Promise<string> {
  const config = getConfiguration(env);
  if ("error" in config) {
    throw new Error(config.error);
  }

  const now = Date.now();
  if (!forceRefresh && cachedToken && cachedToken.expiresAt > now + 60_000) {
    return cachedToken.value;
  }

  if (!forceRefresh && tokenRequest) {
    return tokenRequest;
  }

  const request = (async () => {
    const basicCredentials = btoa(`${config.clientId}:${config.clientSecret}`);
    const response = await fetch(`${config.urls.auth}/oauth2/token`, {
      method: "POST",
      headers: {
        authorization: `Basic ${basicCredentials}`,
        "content-type": "application/x-www-form-urlencoded",
        "user-agent": "HifzAssistant-CloudflareWorker/0.1",
      },
      body: new URLSearchParams({
        grant_type: "client_credentials",
        scope: "content",
      }),
    });

    if (!response.ok) {
      console.error("Quran Foundation token request failed", {
        status: response.status,
        environment: config.environment,
      });
      throw new Error("quran_foundation_auth_failed");
    }

    const payload = (await response.json()) as {
      access_token?: unknown;
      expires_in?: unknown;
    };

    if (
      typeof payload.access_token !== "string" ||
      typeof payload.expires_in !== "number" ||
      !Number.isFinite(payload.expires_in)
    ) {
      throw new Error("quran_foundation_token_response_invalid");
    }

    cachedToken = {
      value: payload.access_token,
      expiresAt: Date.now() + Math.max(payload.expires_in - 60, 30) * 1000,
    };

    return payload.access_token;
  })();

  tokenRequest = request;
  try {
    return await request;
  } finally {
    if (tokenRequest === request) {
      tokenRequest = undefined;
    }
  }
}

async function fetchChapters(env: Env): Promise<Response> {
  const config = getConfiguration(env);
  if ("error" in config) {
    return json({ error: config.error }, 503);
  }

  for (let attempt = 0; attempt < 2; attempt += 1) {
    let accessToken: string;
    try {
      accessToken = await requestAccessToken(env, attempt === 1);
    } catch (error) {
      const code =
        error instanceof Error && error.message.startsWith("quran_foundation_")
          ? error.message
          : "quran_foundation_auth_unavailable";
      return json({ error: code }, 502);
    }

    let upstream: Response;
    try {
      upstream = await fetch(
        `${config.urls.api}/content/api/v4/chapters`,
        {
          method: "GET",
          headers: {
            "x-auth-token": accessToken,
            "x-client-id": config.clientId,
            accept: "application/json",
            "user-agent": "HifzAssistant-CloudflareWorker/0.1",
          },
        },
      );
    } catch {
      return json({ error: "quran_foundation_api_unavailable" }, 502);
    }

    if (upstream.status === 401 && attempt === 0) {
      cachedToken = undefined;
      continue;
    }

    if (!upstream.ok) {
      console.error("Quran Foundation chapters request failed", {
        status: upstream.status,
        environment: config.environment,
      });
      const status = upstream.status === 429 ? 429 : 502;
      return json(
        {
          error:
            upstream.status === 403
              ? "quran_foundation_access_denied"
              : upstream.status === 429
                ? "quran_foundation_rate_limited"
                : "quran_foundation_chapters_unavailable",
        },
        status,
      );
    }

    const payload = (await upstream.json()) as { chapters?: unknown };
    if (!Array.isArray(payload.chapters)) {
      return json({ error: "quran_foundation_response_invalid" }, 502);
    }

    return json({
      source: "Quran.Foundation",
      environment: config.environment,
      chapters: payload.chapters,
    });
  }

  return json({ error: "quran_foundation_auth_retry_exhausted" }, 502);
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method === "OPTIONS") {
      return new Response(null, {
        status: 204,
        headers: {
          "access-control-allow-origin": "*",
          "access-control-allow-methods": "GET, OPTIONS",
          "access-control-allow-headers": "content-type",
          "access-control-max-age": "86400",
        },
      });
    }

    const url = new URL(request.url);

    if (request.method !== "GET") {
      return json({ error: "method_not_allowed" }, 405);
    }

    if (url.pathname === "/health") {
      const config = getConfiguration(env);
      return json({
        status: "ok",
        service: "hifz-assistant-api",
        quranFoundationConfigured: !("error" in config),
        quranFoundationEnvironment:
          "error" in config ? (env.QF_ENV || "prelive") : config.environment,
      });
    }

    if (url.pathname === "/quran/chapters") {
      return fetchChapters(env);
    }

    return json({ error: "not_found" }, 404);
  },
};
