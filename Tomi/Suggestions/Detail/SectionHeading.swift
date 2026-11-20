import SwiftUI

/// The small capital heading above a block of a suggestion.
struct SectionHeading: View {
    let words: LocalizedStringResource

    var body: some View {
        Text(words)
            .textStyle(.showLabel, color: .showMuted)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    ShowCard { SectionHeading(words: .suggestionRecipeTitle) }
        .padding()
        .background { ShowStage() }
}
