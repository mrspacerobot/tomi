import SwiftUI

extension UseTagKind {
    /// What VoiceOver reads after the name of the ingredient, so the source is said in words.
    var value: Text {
        switch self {
        case .fridge: Text(.useTagFridgeValue)
        case .cupboard: Text(.useTagCupboardValue)
        case .missing: Text(.useTagMissingValue)
        }
    }
}
