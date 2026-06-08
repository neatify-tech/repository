try {
	techDetails.value = await updateSessionScopes(
		tenantId.value,
		workspaceId,
		selectedSessionId.value,
		{ allow_scopes: nextAllow, deny_scopes: nextDeny }
	)
	notify('Session scopes updated.')
}
catch (error) {
	notify(error?.message || 'Unable to update scopes.')
}
finally {
	techScopeSaving.value = false
}
