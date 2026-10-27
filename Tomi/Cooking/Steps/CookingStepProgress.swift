import SwiftUI

/// "Step 2 of 5" and a mark for each step. The words carry the state, so the marks are only decoration.
struct CookingStepProgress: View {
    let position: Int
    let count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(.cookingStepsProgress(position, count))
                .textStyle(.label)
                .textCase(.uppercase)
            CookingStepMarks(position: position, count: count)
        }
    }
}

#Preview("Step 2 of 5") { CookingStepProgress(position: 2, count: 5).padding() }
