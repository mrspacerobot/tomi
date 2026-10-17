import SwiftUI

/// A link to every question about the cook.
struct QuestionLinks: View {
    var body: some View {
        ForEach(ProfileQuestion.allCases, id: \.self) { question in
            NavigationLink(value: HomeRoute.question(question)) {
                Text(question.title)
                    .textStyle(.body)
            }
            .accessibilityIdentifier("settings-" + question.identifier)
        }
    }
}
