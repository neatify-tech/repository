<button
	class="control size-xs ghost"
	type="button"
	@click="workerPaneOpen = true">
	Workers: {{ selectedWorkerProgress.done || 0 }}/{{ selectedWorkerProgress.total }} done
	<span v-if="selectedWorkerProgress.failed">· {{ selectedWorkerProgress.failed }} failed</span>
</button>
