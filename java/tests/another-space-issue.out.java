private TagSelectionResponse toResponse(WorkspaceTagSelection state) {
	return new TagSelectionResponse(state.category == null ? null : state.category.id, state.value == null ? null : state.value.id);
}
