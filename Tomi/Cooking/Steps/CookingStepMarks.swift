import SwiftUI

/// A mark for each step, filled up to the step the cook is on. Decoration: the words say where the cook is.
struct CookingStepMarks: View {
    let position: Int
    let count: Int

    var body: some View {
        HStack(spacing: Spacing.xxSmall) {
            ForEach(1...count, id: \.self) { step in
                Capsule()
                    .fill(color(for: step))
                    .frame(height: RuleWeight.double)
            }
        }
        .accessibilityHidden(true)
    }

    private func color(for step: Int) -> Color {
        if step <= position {
            return ColorRole.showAccent.color
        }
        return ColorRole.showSurface.color.opacity(0.5)
    }
}
