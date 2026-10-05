import SwiftUI
import TomiCore

/// "What do you eat?": one tap answers and moves on.
struct OnboardingDietView: View {
    let diets: [Diet]
    let choice: DietChoice?
    let choose: (DietChoice) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            TomiGreeting(words: .onboardingDietGreeting)
            OnboardingDietHeading()
            OnboardingDietRows(diets: diets, choice: choice, choose: choose)
            Text(.onboardingDietHint)
                .textStyle(.description)
                .padding(.horizontal, Spacing.screenMargin)
        }
    }
}
