public class WorkflowDefinitionService {
public ObjectNode enrichDefinition(JsonNode definition) {
        runtimeEdges.set("user_input", edgeObject(
            List.of("default", "tool_exec", "pause"),
            List.of("llm", "tool_exec", "__END__")
        ));
}
}
