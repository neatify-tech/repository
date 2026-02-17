async function loadContentForType(type) {
  const entry = activeContentEntry(type);
  if (!entry || !hasContentUrl(entry)) return;
  const key = activeContentKey(type);
  if (!key || activeContentPayloads.value[key]) return;
  console.info("[mcp-test] load content for tab", { type, url: entry.url });
  activeContentLoading.value = { ...activeContentLoading.value, [key]: true };
  const payload = await resolveUiResource(entry.url);
  activeContentPayloads.value = { ...activeContentPayloads.value, [key]: payload };
  activeContentLoading.value = { ...activeContentLoading.value, [key]: false };
}
