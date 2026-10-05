import SwiftUI
import TomiCore

/// The answers to the diet question: eating everything first, then each diet the table lists.
struct OnboardingDietRows: View {
    let diets: [Diet]
    let choice: DietChoice?
    let choose: (DietChoice) -> Void

    var body: some View {
        VStack(spacing: Spacing.none) {
            TickRow(
                name: String(localized: .onboardingDietEverythingName),
                note: String(localized: .onboardingDietEverythingNote),
                isSelected: choice == .everything,
                action: { choose(.everything) }
            )
            .accessibilityIdentifier("onboarding-diet-everything")
            ForEach(diets) { diet in
                DietRow(diet: diet, isSelected: choice == .diet(diet.id), action: { choose(.diet(diet.id)) })
            }
        }
    }
}
