class Test {
void test() {
			JsonNode result = holder
                .session
	.client()
	.callTool(toolName, effectiveArguments, meta)
	.get(timeout.toMillis(), TimeUnit.MILLISECONDS);
}
}
