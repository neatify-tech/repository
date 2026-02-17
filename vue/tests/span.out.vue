<template>
	<pre
		v-if="!shouldShowIframeForTab(toolResponseTab) && isDiffEntry(activeContentEntry(toolResponseTab))"
		class="content-diff">
		<span
			v-for="(line, lineIndex) in diffLines(activeContentText(toolResponseTab))"
			:key="lineIndex"
			:class="line.className">test: {{ line.text }}</span>
	</pre>
</template>
