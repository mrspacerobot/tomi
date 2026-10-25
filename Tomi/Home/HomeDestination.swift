import SwiftUI

/// The screen for each route from home.
struct HomeDestination: View {
    let route: HomeRoute
    let flow: AppFlowModel
    @Binding var path: [HomeRoute]

    var body: some View {
        switch route {
        case .scan: ScanView(flow: flow, path: $path)
        case .type: ScanView(flow: flow, path: $path, startsWithTyping: true)
        case .settings: SettingsView(flow: flow)
        case .question(let question): SettingsQuestionView(question: question, flow: flow)
        case .suggestion(let suggestion):
            SuggestionDetailView(suggestion: suggestion, options: flow.profile.listedOptions)
        }
    }
}
