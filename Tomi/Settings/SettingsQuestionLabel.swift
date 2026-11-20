import SwiftUI

struct SettingsQuestionLabel: View {
    let question: ProfileQuestion

    var body: some View {
        HStack {
            Text(question.title).textStyle(.showBodyStrong)
            Spacer(minLength: ShowSize.gap)
            Image(systemName: "chevron.forward")
                .foregroundStyle(ColorRole.showMuted.color)
                .accessibilityHidden(true)
        }
    }
}

#Preview { ShowCard { SettingsQuestionLabel(question: .avoid) } }
