    TextMetrics {
        id: labelMetrics

        font.family: ready && taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
        font.pixelSize: ready ? taskbar.fontSize : Style.font.body
        font.weight: chip.foregroundWeight
        text: chip.shortLabel
    }

    Rectangle {
        readonly property bool persistentActive: chip.ready && chip.isActive && taskbar.activeBackgroundEnabled
        readonly property bool showFill: chip.ready && (chip.useHoverStyle || persistentActive || taskbar.normalBackgroundEnabled)

        anchors.fill: parent
        anchors.topMargin: Style.space(1)
        anchors.bottomMargin: Style.space(1)
        anchors.leftMargin: chip.hitHorizontalPadding + Style.space(1)
        anchors.rightMargin: chip.hitHorizontalPadding + Style.space(1)
        radius: chip.ready ? taskbar.itemCornerRadius : 4
        color: showFill ? (chip.useHoverStyle ? taskbar.hoverBackgroundColor : (persistentActive ? taskbar.activeBackgroundColor : taskbar.normalBackgroundColor)) : "transparent"
        opacity: showFill ? 1 : 0
    }

    Row {
        anchors.centerIn: parent
        spacing: chip.contentSpacing
        opacity: chip.foregroundOpacity
        z: 1

        Item {
            width: chip.iconExtent
            height: chip.iconExtent
            visible: chip.effectiveShowIcons

            Image {
                id: appIcon

                anchors.fill: parent
                source: chip.ready ? taskbar.resolveIconSource(chip.resolvedIconName) : ""
                sourceSize.width: Math.round(width * Screen.devicePixelRatio)
                sourceSize.height: Math.round(height * Screen.devicePixelRatio)
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                mipmap: true
                layer.enabled: chip.ready && taskbar.invertIconColors
                layer.smooth: true
                layer.effect: ShaderEffect {
                    property variant source
                    fragmentShader: Qt.resolvedUrl("../shaders/invert.frag.qsb")
                }

            }

            Text {
                anchors.centerIn: parent
                visible: appIcon.status === Image.Error || appIcon.source.toString() === ""
                text: chip.shortLabel.charAt(0).toUpperCase()
                textFormat: Text.PlainText
                color: chip.foregroundColor
                font.family: chip.ready && taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                font.pixelSize: chip.ready ? taskbar.fontSize : Style.font.body
                font.weight: chip.foregroundWeight
            }

        }

        Text {
            visible: chip.effectiveShowLabels
            width: chip.labelExtent
            text: chip.shortLabel
            textFormat: Text.PlainText
            color: chip.foregroundColor
            font.family: chip.ready && taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
            font.pixelSize: chip.ready ? taskbar.fontSize : Style.font.body
            font.weight: chip.foregroundWeight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Behavior on opacity {
            NumberAnimation {
                duration: chip.ready ? taskbar.animationDuration : 0
                easing.type: Easing.OutCubic
            }

        }

    }

    Rectangle {
        readonly property bool dotIndicator: chip.ready && taskbar.activeIndicator === "Dot"
        readonly property bool topIndicator: chip.ready && taskbar.activeIndicator === "Top"
        readonly property real edgeMargin: Style.space(chip.ready ? taskbar.indicatorMargin : 2)

        visible: chip.ready && chip.isActive && taskbar.activeIndicator !== "None"
        width: {
            if (!chip.ready)
                return 0;

            if (dotIndicator)
                return Style.space(taskbar.indicatorSize);

            if (taskbar.indicatorLength > 0)
                return Math.min(chip.calculatedWidth, Style.space(taskbar.indicatorLength));

            return Math.max(Style.space(12), chip.calculatedWidth - Style.space(taskbar.itemHorizontalPadding * 2));
        }
        height: dotIndicator ? width : Style.space(chip.ready ? taskbar.indicatorThickness : 2)
        x: Math.round((parent.width - width) / 2)
        y: topIndicator ? edgeMargin : Math.max(0, parent.height - height - edgeMargin)
        z: 2
        color: chip.ready ? taskbar.indicatorColor : Color.accent
        radius: height / 2

        Behavior on width {
            NumberAnimation {
                duration: chip.ready ? taskbar.animationDuration : 0
                easing.type: Easing.OutCubic
            }

        }

    }
