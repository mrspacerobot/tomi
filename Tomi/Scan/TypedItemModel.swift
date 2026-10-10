import Foundation
import TomiCore

/// What the cook types: the server says what it is, and the cook picks when it could be several things.
@Observable
final class TypedItemModel {
    var text = ""
    /// The typed word that could be several ingredients, while the cook picks one.
    private(set) var choosing: ResolvedLabel?
    /// The typed word the server did not know.
    private(set) var unknownLabel: String?
    private(set) var problem: ProblemText?
    private let api: any TomiAPI

    init(api: any TomiAPI) {
        self.api = api
    }

    /// The ingredient to add when the word was exact, nil otherwise.
    func resolve() async -> NamedOption? {
        let label = text.trimmingCharacters(in: .whitespaces)
        guard !label.isEmpty else {
            return nil
        }
        do {
            return show(try await api.resolve([label]).results.first, for: label)
        } catch {
            problem = ProblemText(error)
            return nil
        }
    }

    func finishChoosing() {
        choosing = nil
        text = ""
    }

    private func show(_ result: ResolvedLabel?, for label: String) -> NamedOption? {
        problem = nil
        guard let result, result.basis != .noMatch else {
            unknownLabel = label
            return nil
        }
        unknownLabel = nil
        return exactOrChoosing(result)
    }

    private func exactOrChoosing(_ result: ResolvedLabel) -> NamedOption? {
        guard let exact = result.exactIngredient else {
            choosing = result
            return nil
        }
        choosing = nil
        text = ""
        return exact
    }
}
