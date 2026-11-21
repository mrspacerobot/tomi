import SwiftUI

struct ShowQuestionChoiceLabel: View {
    let choice: TickChoice
    let selected: Bool

    var body: some View {
        HStack(alignment: .top, spacing: ShowSize.gap) {
            ShowQuestionChoiceMark(selected: selected)
            VStack(alignment: .leading, spacing: ShowSize.compact) {
                Text(verbatim: choice.name).textStyle(.showBodyStrong)
                if let note = choice.note {
                    Text(verbatim: note).textStyle(.showNote)
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    ShowQuestionChoiceLabel(choice: TickChoice(optionID: "first", name: "First"), selected: true)
}
