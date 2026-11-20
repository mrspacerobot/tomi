import Foundation
import TomiCore

/// One line of what the cook has tonight: something the photo showed or the cook typed.
struct ConfirmItem: Identifiable, Equatable {
    let id = UUID()
    let label: String
    /// The ingredient of the server it is, or nil when it matched none and cannot be used.
    let ingredient: NamedOption?
    var isTicked: Bool

    init(_ item: ScanItem) {
        label = item.label
        ingredient = item.ingredient
        isTicked = item.startsTicked
    }

    /// A typed ingredient the cook chose, ticked.
    init(typed ingredient: NamedOption) {
        label = ingredient.name
        self.ingredient = ingredient
        isTicked = true
    }
}
