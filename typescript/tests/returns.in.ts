export async function normalizeResolverResult(
  result: unknown,
  kind: ResourceKind,
  uri: string
): Promise<NormalizedResource> {
  try {
    if (result instanceof Response) {
      if (!result.ok) {
        return {
          ok: false,
          mime: "text/plain",
          body: new Uint8Array(),
          error: `HTTP ${result.status}`,
        };
      }
      const body = new Uint8Array(await result.arrayBuffer());
      const mime = result.headers.get("content-type") || inferMime(kind, uri);
      return { ok: true, mime, body };
    }

    if (result instanceof Blob) {
      const body = new Uint8Array(await result.arrayBuffer());
      const mime = result.type || inferMime(kind, uri);
      return { ok: true, mime, body };
    }

    if (typeof result === "string") {
      const encoder = new TextEncoder();
      const body = encoder.encode(result);
      const mime = inferMime(kind, uri);
      return { ok: true, mime, body };
    }

    if (result instanceof ArrayBuffer) {
      const body = new Uint8Array(result);
      const mime = inferMime(kind, uri);
      return { ok: true, mime, body };
    }

    if (result instanceof Uint8Array) {
      const mime = inferMime(kind, uri);
      return { ok: true, mime, body: result };
    }
  } catch (error) {
    return {
      ok: false,
      mime: "text/plain",
      body: new Uint8Array(),
      error: error instanceof Error ? error.message : "Unknown error",
    };
  }

  return {
    ok: false,
    mime: "text/plain",
    body: new Uint8Array(),
    error: "Unsupported resolver result",
  };
}
