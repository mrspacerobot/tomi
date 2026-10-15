import Foundation

/// What differs between the places the cook types an ingredient: the placeholder and the prefix of the
/// accessibility identifiers UI tests find the field by.
struct TypedItemLook {
    let prompt: LocalizedStringResource
    let identifierPrefix: String

    static let confirm = TypedItemLook(prompt: .confirmTypePrompt, identifierPrefix: "confirm")
    static let cupboard = TypedItemLook(prompt: .questionCupboardPrompt, identifierPrefix: "cupboard")
}
