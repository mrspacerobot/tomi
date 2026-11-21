import SwiftUI

struct ShowQuestionChoiceLabel: View {
    let choice: TickChoice
    let selected: Bool
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        layout {
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

    /// At accessibility sizes the mark sits above the words, so a long word gets the whole row and is never broken.
    private var layout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: ShowSize.compact))
        }
        return AnyLayout(HStackLayout(alignment: .top, spacing: ShowSize.gap))
    }
}

#Preview {
    ShowQuestionChoiceLabel(choice: TickChoice(optionID: "first", name: "First"), selected: true)
}
