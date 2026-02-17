<template>
	<section v-else-if="connectionState === 'connecting'" class="panel">
		<div class="card empty-state">
			<h2>Connecting...</h2>
			<p class="muted">Starting or connecting to {{ currentServerName }}.</p>
		</div>
	</section>
</template>
