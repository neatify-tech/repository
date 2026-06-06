        socketManager.broadcastToSession(
            session.id,
            new WorkspaceSocketEvent("session.error", session.workspace.id, session.id, payload)
        );
