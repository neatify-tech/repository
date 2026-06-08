<template>
	<button
		class="refresh"
		type="button"
		@click="refreshAll"
		:disabled="loading">Refresh</button>
	<button
		class="copy"
		type="button"
		:disabled="!selectedPath || previewLoading"
		@click="copyToClipboard">{{ copyLabel }}</button>
</template>
