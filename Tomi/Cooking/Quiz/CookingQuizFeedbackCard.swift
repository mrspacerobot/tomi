import SwiftUI

struct CookingQuizFeedbackCard: View {
    let outcome: CookingQuizOutcome

    var body: some View {
        ShowSpeechBubble {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                Text(outcome.title).textStyle(.cardTitle)
                CookingQuizOutcomeWords(outcome: outcome)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(outcome.identifier)
    }
}

#Preview { CookingQuizFeedbackCard(outcome: .wrong).padding().background { ShowStage() } }
