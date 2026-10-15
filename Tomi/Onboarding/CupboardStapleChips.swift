import SwiftUI
import TomiCore

/// The everyday staples as chips: on when they are in the cook's cupboard, off when they are not.
struct CupboardStapleChips: View {
    let draft: AnswersDraft

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            CupboardHeader(title: .questionCupboardStaples)
            FlowLayout {
                ForEach(draft.options.staples) { staple in
                    Chip(name: staple.name, kind: kind(of: staple.id)) {
                        draft.toggleStaple(staple.id)
                    }
                    .accessibilityIdentifier("cupboard-" + staple.id.rawValue)
                }
            }
        }
    }

    private func kind(of staple: OptionID) -> ChipKind {
        if draft.cupboard.contains(staple) {
            return .on
        }
        return .off
    }
}

#Preview {
    CupboardStapleChips(draft: .preview())
        .padding()
        .background(ColorRole.paper.color)
}
