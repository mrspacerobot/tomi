import SwiftUI
import TomiCore

/// Graph-authored technique introduction before a cook prepares the adapted recipe.
struct CookingIntroductionView: View {
    let suggestion: Suggestion
    let flow: AppFlowModel
    @Binding var path: [HomeRoute]
    @State private var checkingProfile = false
    @State private var refusal: Refusal?

    private var teaching: Teaching? { suggestion.teaching }
    private var canStart: Bool {
        suggestion.canOfferTeaching
    }

    var body: some View {
        ScrollView { content }
            .background(ColorRole.paper.color)
            .navigationTitle(Text(.cookingIntroductionTitle))
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $refusal) { _ in
                Alert(
                    title: Text(.cookingRefreshRefusedTitle),
                    message: Text(.cookingRefreshRefusedMessage),
                    dismissButton: .default(Text(.commonOkay))
                )
            }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            Text(suggestion.title).textStyle(.displayM)
            CookingIntroductionTeaching(suggestion: suggestion)
            CookingIntroductionActions(
                canStart: canStart,
                checkingProfile: checkingProfile,
                start: start,
                close: { path.removeLast() }
            )
        }
        .padding(Spacing.screenMargin)
    }

    private func start() {
        checkingProfile = true
        Task { await refreshAndOpenPreparation() }
    }

    private func refreshAndOpenPreparation() async {
        defer { checkingProfile = false }
        do {
            try await checkFreshProfile()
        } catch {
            refusal = .profileUnavailable
        }
    }

    private func checkFreshProfile() async throws {
        guard path.last == .introduction(suggestion) else { return }
        let latest = try await flow.profile.refreshProfile()
        guard path.last == .introduction(suggestion) else { return }
        guard suggestion.isChecked(for: latest) else {
            refusal = .restrictionsChanged
            return
        }
        path.append(.preparation(suggestion))
    }

    private enum Refusal: Identifiable { case restrictionsChanged, profileUnavailable; var id: Int { 1 } }
}

private struct CookingIntroductionTeaching: View {
    let suggestion: Suggestion

    var body: some View {
        if let teaching = suggestion.teaching {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                TeachingConceptBox(teaching: teaching)
                DraftTeachingLabel(isDraft: teaching.graphChannel == "draft")
                if suggestion.canOfferTeaching {
                    CookingIntroductionNeeds(suggestion: suggestion)
                } else {
                    Text(.cookingUnavailableAdaptation).textStyle(.body)
                }
            }
        }
    }
}

private struct CookingIntroductionNeeds: View {
    let suggestion: Suggestion

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            RecipeYieldLine(yields: suggestion.recipe.yields)
            ForEach(Array(suggestion.recipe.ingredients.enumerated()), id: \.offset) { _, ingredient in
                RecipeIngredientRow(line: ingredient)
            }
            SuggestionMissingLine(suggestion: suggestion, style: .body)
            equipment
        }
    }

    @ViewBuilder private var equipment: some View {
        if !suggestion.safePlan.equipment.isEmpty {
            Text(.suggestionEquipment(suggestion.safePlan.equipment.map(\.name).formatted(.list(type: .and))))
                .textStyle(.body)
        }
    }
}

private struct TeachingConceptBox: View {
    let teaching: Teaching

    var body: some View {
        VStack(spacing: Spacing.medium) {
            Text(teaching.technique.name).textStyle(.title)
            Text(teaching.introduction.concept).textStyle(.dish)
            Text(teaching.introduction.what).textStyle(.body)
            Text(teaching.introduction.why).textStyle(.body)
        }
        .padding(Spacing.large)
        .frame(maxWidth: .infinity)
        .background(DoubleRuledFrame())
    }
}

private struct DraftTeachingLabel: View {
    let isDraft: Bool

    var body: some View {
        if isDraft {
            Text(.cookingDraftLabel).textStyle(.label).foregroundStyle(ColorRole.stampRed.color)
        }
    }
}

private struct CookingIntroductionActions: View {
    let canStart: Bool
    let checkingProfile: Bool
    let start: () -> Void
    let close: () -> Void

    var body: some View {
        VStack(spacing: Spacing.small) {
            Button(action: start) { Text(.cookingStart).frame(maxWidth: .infinity) }
                .buttonStyle(.tomiPrimary)
                .disabled(!canStart || checkingProfile)
                .accessibilityIdentifier("cooking-start")
            Button(action: close) { Text(.cookingNotTonight).frame(maxWidth: .infinity) }
                .buttonStyle(.tomiSecondary)
        }
    }
}
