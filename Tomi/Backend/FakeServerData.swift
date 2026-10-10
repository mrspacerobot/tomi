import Foundation
import TomiCore

/// The fake server's answers, made from the bundled library so they always name lessons the phone has.
/// The diet and avoid lists are invented test words; ingredient, equipment and cuisine ids come from the lessons,
/// so no Swift file names one.
nonisolated struct FakeServerData: Sendable {
    let lessons: [Lesson]
    let options: LibraryOptions

    init(library: any LessonLibrary) {
        lessons = library.lessons
        options = FakeOptions(lessons: library.lessons, catalog: library.catalog).options
    }

    /// The first two ingredients of the first lesson, sure; its third, unsure; and a thing the server does not know.
    func scan(keepingPhoto: Bool) -> ScanResult {
        var items: [ScanItem] = []
        for (position, ingredient) in options.ingredients.prefix(3).enumerated() {
            items.append(Self.item(ingredient, sure: position < 2))
        }
        items.append(ScanItem(label: FakeOptions.unknownThing, ingredient: nil, confidence: 0.8))
        return ScanResult(scanID: "fake-scan", kept: keepingPhoto, items: items)
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

    /// Every lesson, the first as the special, each checked for the cook's own answers.
    func specials(for profile: CookProfile) -> SpecialsResponse {
        var response = SpecialsResponse()
        let offers = lessons.map { FakeOffer(lesson: $0, options: options).offer(checkedFor: profile) }
        response.special = offers.first
        response.alternatives = Array(offers.dropFirst())
        response.rankedBy = .overlap
        return response
    }
}
