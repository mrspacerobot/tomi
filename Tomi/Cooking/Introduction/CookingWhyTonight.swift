import SwiftUI

/// The optional server supplied reason for ranking this suggestion.
struct CookingWhyTonight: View {
    let reason: String?

    var body: some View {
        if let reason {
            ShowCard {
                VStack(alignment: .leading, spacing: ShowSize.gap) {
                    SectionHeading(words: .cookingWhyTonight)
                    Text(verbatim: reason).textStyle(.showText)
                }
            }
        }
    }
}
