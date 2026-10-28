import SwiftUI

/// What the server said about the last pick, or why it could not be checked, read out by VoiceOver as it arrives.
struct CookingQuizOutcomeNote: View {
    let model: CookingQuizModel

    var body: some View {
        Group {
            if let outcome = model.outcome {
                RuledNote(title: outcome.title, rule: outcome.rule) {
                    CookingQuizOutcomeWords(outcome: outcome)
                }
                .accessibilityIdentifier(outcome.identifier)
            }
        }
        .onChange(of: model.results) {
            announce()
        }
    }

    private func announce() {
        guard let outcome = model.outcome else { return }
        AccessibilityNotification.Announcement(String(localized: outcome.title)).post()
    }
}

#Preview {
    if let round = PreviewSuggestion.make()?.quiz(entryID: UUID()) {
        CookingQuizOutcomeNote(model: CookingQuizModel(round: round, api: CookingQuizPreviewAPI.unanswered))
            .padding()
    }
}
