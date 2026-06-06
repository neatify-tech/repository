return entityManager.createQuery(
		"select t from McpServerTool t join fetch t.mcpServer "
			+ "where t.mcpServer.id in :serverIds and t.deleted = false and t.disabled = false "
			+ "and lower(coalesce(t.mcpServer.toolNamePrefix, '') || coalesce(t.toolAlias, t.toolName)) = "
			+ "lower(:name)",
		McpServerTool.class
	)
	.setParameter("serverIds", allowedServerIds)
	.setParameter("name", name)
	.getResultList();
