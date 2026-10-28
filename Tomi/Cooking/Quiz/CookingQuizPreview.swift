import SwiftUI

/// The quiz screen with the bundled graph suggestion's questions, for previews. The preview server has no quiz, so
/// a check says the quiz needs a connection.
struct CookingQuizPreview: View {
    @State private var path: [HomeRoute] = []

    var body: some View {
        if let suggestion = PreviewSuggestion.make() {
            NavigationStack {
                CookingQuizView(session: CookingSession(suggestion: suggestion), flow: .preview(), path: $path)
            }
        }
    }
}

#Preview { CookingQuizPreview() }
