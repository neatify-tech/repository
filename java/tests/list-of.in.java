public class OllamaProvider implements AiChatModelProvider, AiEmbeddingModelProvider {
@Override
	public List<ProviderProperty> properties() {
		return List.of(
			new ProviderProperty("url", "Ollama URL", ProviderPropertyType.STRING, true,
                "http://localhost:11434", "Ollama base URL", "http://localhost:11434", null, true,
                null, null, null)
		);
	}

	@Override
	public List<AiChatModelDefinition> supportedChatModels() {
		return List.of(
			new OllamaModelDefinition("llama4", "Llama 4", 1_000_000L,
                "Open-weight flagship reasoning; 405B variant supports 1M context.", httpClientFactory, false),
			new OllamaModelDefinition("deepseek-r1", "DeepSeek-R1", 128_000L,
                "Local mathematical proofs, step-by-step logic, and open reasoning.", httpClientFactory, false),
			new OllamaModelDefinition("qwen3.5", "Qwen 3.5", 128_000L,
                "Multilingual performance and efficient MoE coding tasks.", httpClientFactory, false),
			new OllamaModelDefinition("gemma3", "Gemma 3", 128_000L,
                "High-efficiency local multimodal models optimized for NPUs.", httpClientFactory, false),
			new OllamaModelDefinition("gemma4", "Gemma 4", 128_000L,
                "Gemma 4 tuned for compact, local deployments.", httpClientFactory, false),
			new OllamaModelDefinition("gpt-oss", "GPT-OSS", 128_000L,
                "Open-weight GPT-style reasoning for private deployments.", httpClientFactory, false),
			new OllamaModelDefinition("phi4", "Phi-4", 128_000L,
                "Laptop-tier logic performance with strong reasoning.", httpClientFactory, false)
		);
	}
}
