import SwiftUI

struct OnboardingWelcomeLines: View {
    let start: () -> Void

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                OnboardingWelcomeText()
                Button(.openingStartInterview, action: start)
                    .buttonStyle(ShowPrimaryButtonStyle())
                    .accessibilityIdentifier("onboarding-start")
            }
        }
        .padding(.horizontal, ShowSize.edge)
    }
}

#Preview { OnboardingWelcomeLines(start: {}).background { ShowStage() } }
