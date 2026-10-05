import SwiftUI

/// The kicker, title and subtitle that open each question.
struct OnboardingQuestionHeading: View {
    let question: Int
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let titleIdentifier: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(.onboardingQuestion(question, OnboardingStep.questionCount))
                .textStyle(.label, color: .stampRed)
            Text(title)
                .textStyle(.displayL)
                .accessibilityIdentifier(titleIdentifier)
            Text(subtitle)
                .textStyle(.description)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    OnboardingQuestionHeading(
        question: 1,
        title: .onboardingDietTitle,
        subtitle: .onboardingDietSubtitle,
        titleIdentifier: "preview"
    )
    .padding()
    .background(ColorRole.paper.color)
}
