import SwiftUI

struct ShowQuestionChoiceMark: View {
    let selected: Bool

    var body: some View {
        Image(systemName: symbol)
            .textStyle(.showBodyStrong, color: ink)
            .accessibilityHidden(true)
    }

    private var symbol: String {
        if selected { return "checkmark.circle.fill" }
        return "circle"
    }

    private var ink: ColorRole {
        if selected { return .showRed }
        return .showMuted
    }
}

#Preview { ShowQuestionChoiceMark(selected: true) }
