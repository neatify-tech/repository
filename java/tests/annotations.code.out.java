@SuppressWarnings("unchecked")
Stream<Object[]> rows = createPageContentSearchQuery(workspaceId, root, patternText, offset, limit + 1).getResultStream();
