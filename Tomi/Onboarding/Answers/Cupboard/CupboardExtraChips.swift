import SwiftUI

/// The cook's own cupboard items that are not everyday staples. A tap removes one.
struct CupboardExtraChips: View {
    let draft: AnswersDraft

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            CupboardHeader(title: .questionCupboardExtras)
            FlowLayout {
                ForEach(draft.cupboardExtras) { extra in
                    QuestionChip(name: extra.name, kind: .removable) {
                        draft.removeFromCupboard(extra.id)
                    }
                    .accessibilityIdentifier("cupboard-extra-" + extra.id.rawValue)
                }
            }
        }
    }
}

#Preview {
    let draft = AnswersDraft.preview()
    draft.addToCupboard("fake-cumin")
    return CupboardExtraChips(draft: draft)
        .padding()
        .background { ShowStage() }
}
