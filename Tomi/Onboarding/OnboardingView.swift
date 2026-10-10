import SwiftUI

/// The first questions about the cook, built from the server's lists, then home.
struct OnboardingView: View {
    let flow: AppFlowModel

    var body: some View {
        if let options = flow.profile.options {
            OnboardingQuestions(flow: flow, model: OnboardingModel(profile: flow.profile, options: options))
        } else {
            LoadFailedView(flow: flow)
        }
    }
}

#Preview {
    OnboardingView(flow: .preview())
}
