import Foundation
import OSLog
import TomiCore

/// The fake server's answers, from the fixtures `fake-options.json` and `fake-suggestions.json`.
/// The diet and avoid lists are invented test words, so no Swift file names a diet, an ingredient or a cuisine.
nonisolated struct FakeServerData: Sendable {
    static let graphVersion = "fake-graph"
    static let logger = Logger(category: .backend)

    let options: LibraryOptions
    private let suggestionFixtures: [Data]

    init() {
        options = Self.readOptions()
        suggestionFixtures = Self.readSuggestionFixtures()
    }

    /// The first two ingredients of the first lesson, sure; its third, unsure; and a thing the server does not know.
    func scan() -> ScanResult {
        var items: [ScanItem] = []
        for (position, ingredient) in options.ingredients.prefix(3).enumerated() {
            items.append(Self.item(ingredient, sure: position < 2))
        }
        items.append(ScanItem(label: FakeOptions.unknownThing, ingredient: nil, confidence: 0.8))
        return ScanResult(scanID: "fake-scan", kept: true, items: items)
    }

    private static func item(_ ingredient: NamedOption, sure: Bool) -> ScanItem {
        var confidence = ScanItem.sureConfidence / 2
        if sure {
            confidence = 1
        }
        return ScanItem(label: ingredient.name.lowercased(), ingredient: ingredient, confidence: confidence)
    }

    /// Exact when the word is one ingredient's name, ambiguous when it is part of several, none otherwise.
    func resolved(_ label: String) -> ResolvedLabel {
        let word = label.trimmingCharacters(in: .whitespaces).lowercased()
        let exact = options.ingredients.filter { $0.name.lowercased() == word }
        if !exact.isEmpty {
            return ResolvedLabel(label: label, basis: .exact, candidates: exact)
        }
        let partial = options.ingredients.filter { $0.name.lowercased().contains(word) }
        if partial.count > 1 && !word.isEmpty {
            return ResolvedLabel(label: label, basis: .ambiguous, candidates: partial)
        }
        return ResolvedLabel(label: label, basis: .noMatch, candidates: [])
    }

    /// Every fixture as a graph suggestion, the first as the special, each checked for the cook's own answers, in
    /// the answer a real server sends, so the app reads it the same way. With photos, the special names the fake
    /// dish photo, which shows its dish; the alternatives name none, as no photo of their dishes exists.
    func suggestions(for profile: CookProfile, withPhotos: Bool = false) throws -> SuggestionsResponse {
        let offers = try checkedOffers(for: profile, withPhotos: withPhotos)
        let answer: [String: Any] = [
            "graphVersion": Self.graphVersion,
            "rankedBy": RankedBy.overlap.rawValue,
            "special": offers.first as Any,
            "alternatives": Array(offers.dropFirst()),
        ]
        let data = try JSONSerialization.data(withJSONObject: answer)
        return try JSONDecoder().decode(SuggestionsResponse.self, from: data)
    }

    private func checkedOffers(for profile: CookProfile, withPhotos: Bool) throws -> [[String: Any]] {
        var offers = try suggestionFixtures.map { try Self.offer($0, checkedFor: profile) }
        guard withPhotos, !offers.isEmpty else {
            return offers
        }
        offers[0]["photoUrl"] = FakeDishPhoto.address
        return offers
    }

    /// The backend's teaching suggestion, asking the invented quiz in place of the graph's, or no quiz without one.
    func guidedSuggestion(for profile: CookProfile, quiz: FakeQuiz?) throws -> SuggestionsResponse {
        var response = SuggestionsResponse()
        response.rankedBy = .overlap
        response.special = try FakeGuidedSuggestion.read(profile: profile, quiz: quiz)
        return response
    }
}
