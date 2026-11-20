#if DEBUG
    enum ShowGalleryTab {
        case episodeGuide
        case table
        case fridge
        case settings

        static let items = [
            ShowTabItem(
                id: Self.episodeGuide,
                title: .showGalleryEpisodeGuide,
                symbol: "point.topleft.down.to.point.bottomright.curvepath"
            ),
            ShowTabItem(id: Self.table, title: .showGalleryTable, symbol: "circle.circle"),
            ShowTabItem(id: Self.fridge, title: .showGalleryFridge, symbol: "refrigerator"),
            ShowTabItem(id: Self.settings, title: .settingsTitle, symbol: "person.crop.circle"),
        ]
    }
#endif
