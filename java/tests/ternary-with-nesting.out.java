candidates = activeServerIds.isEmpty()
	? entityManager.createQuery(
			"select s from McpServer s where s.workspace.id = :workspaceId "
				+ "and s.visibility = :visibility order by lower(s.name)",
			McpServer.class
		)
		.setParameter("workspaceId", session.workspace.id)
		.setParameter("visibility", be.celerex.polymr.model.McpServerVisibility.AVAILABLE)
		.getResultList()
	: entityManager.createQuery(
			"select s from McpServer s where s.workspace.id = :workspaceId "
				+ "and s.visibility = :visibility and s.id not in :activeIds order by lower(s.name)",
			McpServer.class
		)
		.setParameter("workspaceId", session.workspace.id)
		.setParameter("visibility", be.celerex.polymr.model.McpServerVisibility.AVAILABLE)
		.setParameter("activeIds", activeServerIds)
		.getResultList();
