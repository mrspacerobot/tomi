import SwiftUI

struct OnboardingHeader: View {
    let completed: Int
    let total: Int
    let back: () -> Void

    var body: some View {
        HStack(spacing: ShowSize.gap) {
            ShowBackButton(action: back)
                .accessibilityIdentifier("onboarding-back")
            ShowLowerThird(label: .openingQuestionCount(completed + 1, total), title: .openingContestantProfile)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, ShowSize.edge)
    }
}

#Preview { OnboardingHeader(completed: 2, total: 7, back: {}).background { ShowStage() } }
