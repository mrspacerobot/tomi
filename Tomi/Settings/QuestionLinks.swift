import SwiftUI

struct QuestionLinks: View {
    var body: some View {
        ForEach(ProfileQuestion.allCases, id: \.self) { question in
            NavigationLink(value: HomeRoute.question(question)) {
                ShowCard { SettingsQuestionLabel(question: question) }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("settings-" + question.identifier)
        }
    }
}

#Preview { NavigationStack { QuestionLinks().padding().background { ShowStage() } } }
