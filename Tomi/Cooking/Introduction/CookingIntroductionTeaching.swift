import SwiftUI
import TomiCore

/// Graph-authored technique prose and the recipe details it explains.
struct CookingIntroductionTeaching: View {
    let suggestion: Suggestion

    var body: some View {
        if let teaching = suggestion.teaching {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                DraftTeachingLabel(isDraft: teaching.graphChannel == .draft)
                TeachingConceptBox(teaching: teaching)
                contentOrRefusal
            }
        }
    }

    @ViewBuilder private var contentOrRefusal: some View {
        if suggestion.canOfferTeaching {
            CookingIntroductionNeeds(suggestion: suggestion)
        } else {
            Text(.cookingUnavailableAdaptation).textStyle(.body)
        }
    }
}
