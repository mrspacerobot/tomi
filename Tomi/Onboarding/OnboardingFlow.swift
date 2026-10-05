import SwiftUI
import TomiCore

/// Onboarding from the welcome to the last question there is so far. The model decides where the cook is;
/// this lays the current screen out under the header.
struct OnboardingFlow: View {
    let model: OnboardingModel
    let table: IngredientTable

    var body: some View {
        VStack(spacing: Spacing.none) {
            if model.step != .welcome {
                OnboardingHeader(completed: model.progressCompleted, back: model.back)
            }
            screen
            if model.couldNotSave {
                Text(.onboardingSaveFailed)
                    .textStyle(.description, color: .stampRed)
                    .padding(Spacing.screenMargin)
                    .accessibilityIdentifier("onboarding-save-failed")
            }
        }
        .background(ColorRole.paper.color)
    }

    @ViewBuilder private var screen: some View {
        switch model.step {
        case .welcome:
            OnboardingWelcomeView(start: model.start)
        case .diet:
            ScrollView { diet }
        case .avoid:
            avoid
        }
    }

    private var diet: some View {
        OnboardingDietView(diets: table.diets, choice: model.dietChoice, choose: model.choose)
    }

    private var avoid: some View {
        ScrollView {
            OnboardingAvoidView(
                items: table.avoidItems,
                answer: model.avoidAnswer,
                tap: model.tapAvoid,
                tapNone: model.tapNone
            )
        }
        .safeAreaInset(edge: .bottom) {
            OnboardingAvoidFooter(
                avoidedNames: model.avoidedNames(in: table),
                canContinue: model.canContinue,
                action: model.continueFromAvoid
            )
        }
    }
}

#Preview("Welcome") {
    if let model = OnboardingModel.preview(), let table = BundledLibrary.ingredientTable() {
        OnboardingFlow(model: model, table: table)
    }
}

#Preview("Diet") {
    if let model = OnboardingModel.preview(at: .diet), let table = BundledLibrary.ingredientTable() {
        OnboardingFlow(model: model, table: table)
    }
}

#Preview("What to avoid, dark, largest text") {
    if let model = OnboardingModel.preview(at: .avoid), let table = BundledLibrary.ingredientTable() {
        OnboardingFlow(model: model, table: table)
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.accessibility5)
    }
}
