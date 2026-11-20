import SwiftUI

/// Where the cook is, in words ("Step 2 of 5", "Question 1 of 2"), over a mark for each place. The words carry the
/// state, so the marks are only decoration.
struct CookingProgress: View {
    let words: LocalizedStringResource
    let marks: CookingMarks

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(words)
                .textStyle(.showLabel)
                .textCase(.uppercase)
            CookingStepMarks(position: marks.position, count: marks.count)
        }
    }
}

#Preview("Step 2 of 5") {
    CookingProgress(words: .cookingStepsProgress(2, 5), marks: CookingMarks(position: 2, count: 5)).padding()
}
