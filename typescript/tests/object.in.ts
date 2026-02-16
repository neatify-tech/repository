async function callTool(
  name: string,
  argumentsParam: Record<string, unknown> = {},
  meta?: Record<string, unknown>
) {
  const call = ensureMcp();
  const payload: { name: string; arguments?: Record<string, unknown>; _meta?: Record<string, unknown> } = {
    name,
    arguments: argumentsParam,
  };
  if (meta) {
    payload._meta = meta;
  }
  console.debug("[mcp-ui] tool call", payload);
  const result = await call(payload);
  console.debug("[mcp-ui] tool result", name, result);
  return result;
}
