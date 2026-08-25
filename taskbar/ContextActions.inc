            MenuSeparator {
                visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
            }

            Repeater {
                model: taskbar && taskbar.contextWindows ? taskbar.contextWindows : []

                MenuRow {
                    required property var modelData

                    taskbar: taskbar
                    text: taskbar.windowTitle(modelData) || taskbar.windowLabel(modelData)
                    iconText: taskbar.activeWindow === modelData ? "\uf111" : ""
                    onTriggered: {
                        taskbar.close();
                        taskbar.activateOrLaunch(null, modelData);
                    }
                }

            }

            MenuSeparator {
                visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
            }

            MenuRow {
                taskbar: taskbar
                visible: {
                    if (!taskbar)
                        return false;

                    return !!taskbar.contextCanLaunch;
                }
                text: "New Window"
                iconText: "\uf2d2"
                onTriggered: taskbar.launchContextNewWindow()
            }

            Repeater {
                model: taskbar && taskbar.contextActions ? taskbar.contextActions : []

                MenuRow {
                    required property var modelData

                    taskbar: taskbar
                    text: taskbar.asPlainUiText(String(modelData.name || modelData.id || "Application Action"))
                    iconText: "\uf144"
                    onTriggered: taskbar.executeDesktopAction(modelData)
                }

            }

            MenuRow {
                taskbar: taskbar
                enabled: {
                    if (!taskbar)
                        return false;

                    return !!(taskbar.contextIsPinned || taskbar.contextCanLaunch);
                }
                text: {
                    if (!taskbar)
                        return "Pin to Taskbar";

                    return taskbar.contextIsPinned ? "Unpin from Taskbar" : "Pin to Taskbar";
                }
                iconText: {
                    if (!taskbar)
                        return "\uf08d";

                    return taskbar.contextIsPinned ? "\uf127" : "\uf08d";
                }
                onTriggered: taskbar.toggleContextPin()
            }

            MenuSeparator {
                visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
            }

            MenuRow {
                taskbar: taskbar
                visible: {
                    if (!taskbar || !taskbar.contextWindows)
                        return false;

                    return taskbar.contextWindows.length > 1;
                }
                text: {
                    var count = taskbar && taskbar.contextWindows ? taskbar.contextWindows.length : 0;
                    return "Close " + count + " Windows";
                }
                iconText: "\uf2d4"
                destructive: true
                onTriggered: taskbar.closeContextWindows()
            }

            MenuRow {
                taskbar: taskbar
                visible: {
                    if (!taskbar || !taskbar.contextWindows)
                        return false;

                    return taskbar.contextWindow !== null && taskbar.contextWindows.length > 0;
                }
                text: "Close Window"
                iconText: "\uf00d"
                destructive: true
                onTriggered: taskbar.closeContextWindow()
            }
