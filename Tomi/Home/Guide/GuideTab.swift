enum GuideTab {
    case guide
    case seasons
    case fridge
    case settings

    var route: HomeRoute? {
        switch self {
        case .guide: nil
        case .seasons: .seasons
        case .fridge: .scan
        case .settings: .settings
        }
    }

    static let items: [ShowTabItem<Self>] = [
        .init(id: .guide, title: .guideTitle, icon: .symbol("point.topleft.down.to.point.bottomright.curvepath")),
        .init(id: .seasons, title: .guideAllSeasons, icon: .symbol("square.grid.2x2"), identifier: "guide-seasons-tab"),
        .init(id: .fridge, title: .homeScan, icon: .symbol("refrigerator"), identifier: "guide-fridge-tab"),
        .init(id: .settings, title: .homeSettings, icon: .host, identifier: "home-settings"),
    ]
}
