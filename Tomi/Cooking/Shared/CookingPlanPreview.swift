import SwiftUI
import TomiCore

/// Fake graph suggestion for design previews, drawn from the bundled graph suggestion fixture.
struct CookingPlanPreview: View {
    enum Screen { case detail, introduction, preparation, steps }

    let screen: Screen
    @State private var path: [HomeRoute] = []
    @State private var suggestion: Suggestion?

    var body: some View {
        Group {
            if let suggestion {
                destination(suggestion)
            } else {
                ProgressView()
            }
        }
        .task { suggestion = PreviewSuggestion.make() }
    }

    @ViewBuilder private func destination(_ suggestion: Suggestion) -> some View {
        switch screen {
        case .detail:
            SuggestionDetailView(suggestion: suggestion, options: LibraryOptions(), path: $path)
        case .introduction:
            CookingIntroductionView(suggestion: suggestion, flow: .preview(), path: $path)
        case .preparation:
            CookingPreparationView(suggestion: suggestion, flow: .preview(), path: $path)
        case .steps:
            CookingStepsView(session: CookingSession(suggestion: suggestion), flow: .preview(), path: $path)
        }
    }
}

#Preview("Recipe details") { CookingPlanPreview(screen: .detail) }
#Preview("Cooking introduction") { CookingPlanPreview(screen: .introduction) }
#Preview("Preparation") { CookingPlanPreview(screen: .preparation) }
#Preview("Cooking steps") { CookingPlanPreview(screen: .steps) }
