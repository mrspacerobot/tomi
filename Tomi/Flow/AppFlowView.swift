import SwiftUI

/// The screen for each stage of the app's order.
struct AppFlowView: View {
    let flow: AppFlowModel
    let progress: SavedProgressModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            switch flow.stage {
            case .starting: StartingView()
            case .signedOut: SignInView(flow: flow)
            case .onboarding: OnboardingView(flow: flow)
            case .home: HomeView(flow: flow, progress: progress)
            case .failed: LoadFailedView(flow: flow)
            }
        }
        .task {
            await flow.start()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                flow.appBecameActive()
            }
        }
    }
}
