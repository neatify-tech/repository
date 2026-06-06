        String previousLogical = run == null || run.checkpointJson == null
            ? null
            : run.checkpointJson.path(ConversationGraphState.LOGICAL_NODE_INSTANCE_ID).asText(null);
