    readonly property var actionOptions: ["Focus or Launch", "Open Context Menu", "New Window", "Close Window", "Close All Windows", "Toggle Pin", "Open Settings", "Do Nothing"]
    readonly property var pages: [{
            "id": "applications",
            "label": "Applications",
            "description": "Pins, running windows, and filters"
        }, {
            "id": "clicks",
            "label": "Clicks",
            "description": "Mouse and modifier actions"
        }, {
            "id": "content",
            "label": "Icons & labels",
            "description": "Visibility, format, and type size"
        }, {
            "id": "layout",
            "label": "Chip layout",
            "description": "Width, padding, gaps, and rounding"
        }, {
            "id": "bar",
            "label": "Bar",
            "description": "Chrome padding, fill, and separators"
        }, {
            "id": "colors",
            "label": "Colors",
            "description": "Normal, hover, and active styles"
        }, {
            "id": "indicator",
            "label": "Indicator",
            "description": "Active-window mark"
        }, {
            "id": "previews",
            "label": "Previews",
            "description": "Hover thumbnails and motion"
        }]
    readonly property int pageIndex: {
        if (currentPage === "")
            return 0;
        for (var i = 0; i < pages.length; i++) {
            if (pages[i].id === currentPage)
                return i + 1;
        }
        return 0;
    }
    readonly property string currentPageLabel: pageIndex === 0 ? "OmaPanel Settings" : pages[pageIndex - 1].label
    readonly property string currentPageDescription: pageIndex === 0 ? "Changes are saved instantly" : pages[pageIndex - 1].description
