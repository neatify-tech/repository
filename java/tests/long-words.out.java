List<SessionEvent> events = entityManager.createQuery(
		"select e from SessionEvent e where e.session.id = :sessionId and e.eventType = "
			+ ":type order by e.createdAt desc",
		SessionEvent.class
	)
	.setParameter("sessionId", sessionId)
	.setParameter("type", SessionEventType.ASSISTANT_MESSAGE)
	.setMaxResults(1)
	.getResultList();
