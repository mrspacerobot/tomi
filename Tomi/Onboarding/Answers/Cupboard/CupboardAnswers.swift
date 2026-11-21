import SwiftUI
import TomiCore

/// What the cook always has at home: the everyday staples as chips, their own extras, and a field to add more.
/// Until the cook has answered, the chips show what the server assumes, and saving records exactly what is shown.
struct CupboardAnswers: View {
    let draft: AnswersDraft
    @State private var typing: TypedItemModel

    init(draft: AnswersDraft) {
        self.draft = draft
        _typing = State(initialValue: TypedItemModel(api: draft.api))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            if !draft.options.staples.isEmpty {
                CupboardStapleChips(draft: draft)
            }
            if !draft.cupboardExtras.isEmpty {
                CupboardExtraChips(draft: draft)
            }
            TypedItemField(typing: typing, look: .cupboard) { draft.addToCupboard($0.id) }
            Text(.questionCupboardSaved(draft.cupboard.count))
                .textStyle(.showLede)
                .accessibilityIdentifier("cupboard-count")
        }
        .onAppear {
            draft.answers.answerCupboard(assumedUntilAnswered: draft.options.assumedStaples)
        }
    }
}

#Preview {
    ScrollView {
        CupboardAnswers(draft: .preview())
            .padding()
    }
    .background { ShowStage() }
    .dynamicTypeSize(.accessibility5)
}
