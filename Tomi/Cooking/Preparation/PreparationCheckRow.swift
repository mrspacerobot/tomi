import SwiftUI

struct PreparationCheckRow: View {
    let choice: TickChoice
    let selected: Bool
    let toggle: () -> Void

    var body: some View {
        ShowQuestionChoice(choice: choice, selected: selected, action: toggle)
    }
}

#Preview {
    PreparationCheckRow(choice: TickChoice(optionID: nil, name: "Pan"), selected: true, toggle: {})
}
