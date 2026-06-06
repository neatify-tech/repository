public class McpResource {
	public static class ServerStatus {
		public boolean running;
		public String command;
		public JsonNode capabilities;
		public JsonNode initialize;

		public ServerStatus() {
		// comment here
		}

		public ServerStatus(boolean running, String command, JsonNode capabilities, JsonNode initialize) {
      this.running = running;
      this.command = command;
      this.capabilities = capabilities;
      this.initialize = initialize;
    }
	}
}
