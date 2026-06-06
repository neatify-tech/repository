class Test {
	@Inject
	@ManagedExecutorConfig(cleared = ThreadContext.TRANSACTION) // Avoid propagating a completed transaction to
	// post-commit async dispatch.
	ManagedExecutor dispatchExecutor;

	@Inject
	LlmCallRegistry callRegistry;
}
