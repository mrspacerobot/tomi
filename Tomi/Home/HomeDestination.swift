import SwiftUI

/// The screen for each route from home.
struct HomeDestination: View {
    let route: HomeRoute
    let flow: AppFlowModel
    @Binding var path: [HomeRoute]

    var body: some View {
        switch route {
        case .scan: ScanView(flow: flow, path: $path)
        case .settings: SettingsView(flow: flow)
        case .question(let question): SettingsQuestionView(question: question, flow: flow)
        case .suggestion(let suggestion):
            SuggestionDetailView(suggestion: suggestion, options: flow.profile.listedOptions, path: $path)
        case .introduction(let suggestion):
            CookingIntroductionView(suggestion: suggestion, flow: flow, path: $path)
        case .preparation(let suggestion):
            CookingPreparationView(suggestion: suggestion, flow: flow, path: $path)
        case .steps(let suggestion):
            CookingStepsView(suggestion: suggestion, path: $path)
        }
    }
}
