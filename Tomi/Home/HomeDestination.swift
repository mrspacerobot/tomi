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
        case .offer(let offer): OfferDetailView(offer: offer, options: flow.profile.listedOptions)
        }
    }
}
