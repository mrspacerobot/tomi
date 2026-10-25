import Foundation

extension ProfileQuestion {
    var title: LocalizedStringResource {
        switch self {
        case .diet: .questionDietTitle
        case .avoid: .questionAvoidTitle
        case .cuisines: .questionCuisinesTitle
        case .kitchen: .questionKitchenTitle
        case .cupboard: .questionCupboardTitle
        case .experience: .questionExperienceTitle
        case .table: .questionTableTitle
        }
    }

    var hint: LocalizedStringResource {
        switch self {
        case .diet: .questionDietHint
        case .avoid: .questionAvoidHint
        case .cuisines: .questionCuisinesHint
        case .kitchen: .questionKitchenHint
        case .cupboard: .questionCupboardHint
        case .experience: .questionExperienceHint
        case .table: .questionTableHint
        }
    }

    /// For UI tests, which find a question by it.
    var identifier: String {
        "question-" + String(describing: self)
    }
}
