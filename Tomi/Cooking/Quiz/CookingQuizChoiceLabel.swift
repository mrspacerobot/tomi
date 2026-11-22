import SwiftUI

struct CookingQuizChoiceLabel: View {
    let words: String
    let position: Int
    let ruledOut: Bool

    var body: some View {
        HStack(alignment: .top, spacing: ShowSize.gap) {
            CookingQuizChoiceKey(position: position)
            VStack(alignment: .leading, spacing: ShowSize.compact) {
                Text(verbatim: words).textStyle(.showBody).strikethrough(ruledOut)
                if ruledOut { Text(.cookingQuizNotRight).textStyle(.showNote) }
            }
            .multilineTextAlignment(.leading)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ShowCard {
        CookingQuizChoiceLabel(words: "Pan", position: 0, ruledOut: true)
    }
}
