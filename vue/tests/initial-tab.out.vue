<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch, nextTick } from 'vue';
import { useVAD } from '../services/useVAD';
import { usePiperTts } from '../services/piperTts';
</script>
<style scoped>
.telemetry-content {
	display: flex;
	align-items: center;
	gap: 0.45rem;
	flex-wrap: wrap;
	flex-direction: column;
}
</style>
<template>
	<div>test</div>
</template>
