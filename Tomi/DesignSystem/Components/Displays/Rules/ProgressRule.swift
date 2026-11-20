import SwiftUI

/// The segmented rule at the top of a lesson, a quiz or onboarding: one segment for each step or question.
/// VoiceOver reads it as one thing, "Progress, 2 of 6".
struct ProgressRule: View {
    let completed: Int
    let total: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<total, id: \.self) { index in
                ProgressSegment(isDone: index < completed, isFirst: index == 0)
            }
        }
        .frame(height: RuleWeight.double)
        .background {
            Hairline()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(.progressLabel))
        .accessibilityValue(Text(.progressValue(completed, total)))
    }
}

#Preview("Light") {
    VStack(spacing: Spacing.large) {
        ProgressRule(completed: 0, total: 4)
        ProgressRule(completed: 2, total: 6)
        ProgressRule(completed: 6, total: 6)
    }
    .padding()
    .background { ShowStage() }
}

#Preview("Dark, largest text") {
    ProgressRule(completed: 4, total: 6)
        .padding()
        .background { ShowStage() }
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.accessibility5)
}
