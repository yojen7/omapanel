    function openContextMenu(anchor, app, toplevel) {
        settingsPanelOpen = false;
        contextAnchor = anchor;
        contextApp = descriptorFor(app, toplevel);
        contextWindow = toplevel;
        contextMenuOpen = true;
    }

    function close() {
        contextMenuOpen = false;
        settingsPanelOpen = false;
        cancelPreview(null);
    }

    function clearPendingPreview() {
        previewTimer.stop();
        pendingPreviewAnchor = null;
        pendingPreviewToplevel = null;
    }

    function commitPreview(anchor, toplevel) {
        clearPendingPreview();
        previewAnchor = anchor;
        previewToplevel = toplevel;
    }

    function requestPreview(anchor, toplevel) {
        if (!showWindowPreviews || !toplevel) {
            cancelPreview(null);
            return ;
        }
        pendingPreviewAnchor = anchor;
        pendingPreviewToplevel = toplevel;
        if (previewDelay <= 0)
            commitPreview(anchor, toplevel);
        else
            previewTimer.restart();
    }

    function cancelPreview(toplevel) {
        if (!toplevel || pendingPreviewToplevel === toplevel)
            clearPendingPreview();

        if (!toplevel || previewToplevel === toplevel) {
            previewToplevel = null;
            previewAnchor = null;
        }
    }

    function previewToplevelAlive(toplevel) {
        if (!toplevel)
            return false;

        if (runningWindows.indexOf(toplevel) >= 0)
            return true;

        for (var i = 0; i < pinnedItems.length; i++) {
            if (pinnedItems[i].window === toplevel)
                return true;

        }
        return false;
    }

    function openSettingsPanel() {
        contextMenuOpen = false;
        Qt.callLater(function() {
            settingsPanelOpen = true;
        });
    }
