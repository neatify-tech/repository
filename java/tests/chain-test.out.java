private int nextCheckpointIndex(UUID runId) {
	Integer current = entityManager.createQuery(
			"select max(c.stepIndex) from WorkflowRunCheckpoint c where c.workflowRun.id = :runId",
			Integer.class
		)
		.setParameter("runId", runId)
		.getSingleResult();
	return current == null ? 1 : current + 1;
}
