export class McpViewElement extends HTMLElement {
	private render(): void {
		if (!this.isConnected) return;
		const uri = this.getRootUri();
		if (!uri) return;
		void this.load(uri);
	}
}
