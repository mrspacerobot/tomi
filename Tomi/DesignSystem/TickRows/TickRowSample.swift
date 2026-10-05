import Foundation

/// A made-up answer for previews of tick rows and for the component gallery.
struct TickRowSample {
    let nameWords: LocalizedStringResource
    var noteWords: LocalizedStringResource?

    /// A question with one answer, as on the diet screen of onboarding.
    static let diets = [
        TickRowSample(nameWords: .sampleTickEverythingName, noteWords: .sampleTickEverythingNote),
        TickRowSample(nameWords: .sampleTickVegetarianName, noteWords: .sampleTickVegetarianNote),
        TickRowSample(nameWords: .sampleTickVeganName, noteWords: .sampleTickVeganNote),
    ]

    /// A question with several answers, as on the kitchen screen. The last row has no note.
    static let equipment = [
        TickRowSample(nameWords: .sampleTickOvenName, noteWords: .sampleTickOvenNote),
        TickRowSample(nameWords: .sampleTickBlenderName, noteWords: .sampleTickBlenderNote),
        TickRowSample(nameWords: .sampleTickProcessorName),
    ]

    var name: String {
        String(localized: nameWords)
    }

    var note: String? {
        guard let noteWords else {
            return nil
        }
        return String(localized: noteWords)
    }
}
