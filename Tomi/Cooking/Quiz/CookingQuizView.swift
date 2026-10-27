import SwiftUI
import TomiCore

/// The quiz after the steps, one question at a time, as the server sent it. Each pick goes to the server, which
/// says right or wrong and explains once right. The screen holds no right choice and shows no score or XP.
struct CookingQuizView: View {
    @Binding var path: [HomeRoute]
    @State private var model: CookingQuizModel?

    init(session: CookingSession, flow: AppFlowModel, path: Binding<[HomeRoute]>) {
        self._path = path
        _model = State(initialValue: session.quiz.map { CookingQuizModel(round: $0, api: flow.services.api) })
    }

    var body: some View {
        ScrollView { content }
            .id(model?.round.position)
            .background(ColorRole.paper.color)
            .navigationTitle(Text(.cookingQuizTitle))
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityIdentifier("cooking-quiz")
    }

    @ViewBuilder private var content: some View {
        if let model, !model.round.isFinished {
            CookingQuizPage(model: model, path: $path)
        } else {
            CookingQuizDone(path: $path)
        }
    }
}

#Preview {
    CookingQuizPreview()
}
