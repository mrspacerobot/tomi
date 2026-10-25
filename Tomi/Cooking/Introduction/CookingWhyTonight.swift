import SwiftUI

/// The optional server supplied reason for ranking this suggestion.
struct CookingWhyTonight: View {
    let reason: String?

    var body: some View {
        if let reason {
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                SectionHeading(words: .cookingWhyTonight)
                Text(verbatim: reason).textStyle(.body)
            }
        }
    }
}
