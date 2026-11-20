enum CompanionAppearance {
    case tastingMenu
    case cookingShow

    var palette: CompanionPalette {
        switch self {
        case .tastingMenu: .tokens
        case .cookingShow: .cookingShow
        }
    }
}
