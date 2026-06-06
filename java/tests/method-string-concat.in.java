private JsonNode loadReleasedDefinition(UUID workflowId) {
		return entityManager.createQuery(
				"select v.definitionJson from WorkflowDefinitionVersion v where v.workflowDefinition.id = :workflowId "
						+ "and v.releasedAt is not null and v.deprecatedAt is null",
				JsonNode.class).setParameter("workflowId", workflowId).setMaxResults(1).getResultStream().findFirst()
				.orElse(null);
}
