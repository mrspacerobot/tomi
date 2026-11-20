import SwiftUI
import TomiCore

/// The screen for each route from home.
struct HomeDestination: View {
    let route: HomeRoute
    let flow: AppFlowModel
    let progress: ProgressModel
    @Binding var path: [HomeRoute]

    private var courses: [OptionCourse] {
        flow.profile.options?.courses ?? []
    }

    var body: some View {
        switch route {
        case .scan: ScanView(flow: flow, path: $path)
        case .type: ScanView(flow: flow, path: $path, startsWithTyping: true)
        case .settings: SettingsView(flow: flow, currentProgress: progress.shown)
        case .seasons: AllSeasonsView(options: courses, skills: progress.shown?.snapshot?.skills)
        case .episode(let skill):
            if let data = EpisodeData.find(skill, options: courses, snapshot: progress.shown?.snapshot?.skills) {
                EpisodeView(data: data)
            }
        case .question(let question): SettingsQuestionView(question: question, flow: flow)
        case .suggestion(let suggestion):
            SuggestionDetailView(suggestion: suggestion, options: flow.profile.listedOptions, path: $path)
        case .introduction(let suggestion):
            CookingIntroductionView(suggestion: suggestion, flow: flow, path: $path)
        case .preparation(let suggestion):
            CookingPreparationView(suggestion: suggestion, flow: flow, path: $path)
        case .steps(let session):
            CookingStepsView(session: session, flow: flow, path: $path)
        case .quiz(let session):
            CookingQuizView(session: session, flow: flow, path: $path)
        }
    }
}
