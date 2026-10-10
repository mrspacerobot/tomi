import SwiftUI

/// Shown when the cook's answers could not be fetched, with a way to try again.
struct LoadFailedView: View {
    let flow: AppFlowModel

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text(.loadFailedTitle)
                .textStyle(.title)
            if let problem = flow.problem {
                ProblemView(problem: problem)
            }
            RetryButton(flow: flow)
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    LoadFailedView(flow: .preview())
}
