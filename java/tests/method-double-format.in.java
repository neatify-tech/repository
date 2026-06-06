 private void validateEdges(ObjectNode edges, ObjectNode nodes, java.util.Map<String, String> nodeTypes, JsonNode endNodes, JsonNode returnNodes) {
        java.util.Set<String> terminalNodeIds = new java.util.HashSet<>();
        if (endNodes != null && endNodes.isArray()) {
            for (JsonNode entry : endNodes) {
                if (entry != null) {
                    String endNodeId = entry.asText(null);
                    if (endNodeId != null && !endNodeId.isBlank()) {
                        terminalNodeIds.add(endNodeId);
                    }
                }
            }
        }
}
