import SwiftUI
import TomiCore

/// Everything the cook does not eat, as many as they like, in the server's two groups.
/// Saved ids the server no longer lists stay ticked, so taking them away needs the cook's yes like any other.
struct AvoidAnswers: View {
    let draft: AnswersDraft
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.none) {
            AvoidGroup(title: .questionAvoidGroupAllergens, choices: choices(of: .allergen), draft: draft)
            AvoidGroup(title: .questionAvoidGroupChoices, choices: choices(of: .choice), draft: draft)
            AvoidGroup(title: nil, choices: unreadableChoices, draft: draft)
            NoneOfTheseRow(draft: draft)
            if showStyle { AvoidSearch(draft: draft) }
            AvoidNote()
        }
    }

    private func choices(of kind: AvoidKind) -> [TickChoice] {
        draft.options.avoidItems(of: kind).map { TickChoice(optionID: $0.id, name: $0.name) }
    }

    private var unreadableChoices: [TickChoice] {
        let name = String(localized: .questionAvoidUnreadable)
        return draft.options.unlistedAvoidIDs(in: draft.startingAvoid).map { TickChoice(optionID: $0, name: name) }
    }
}

#Preview("Light") {
    ScrollView {
        AvoidAnswers(draft: .preview())
    }
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text") {
    ScrollView {
        AvoidAnswers(draft: .preview(saved: [FakeOptions.unlistedSavedItem]))
    }
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
