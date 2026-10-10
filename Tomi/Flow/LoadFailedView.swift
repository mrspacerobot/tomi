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
            Button {
                Task { await flow.start() }
            } label: {
                Text(.loadFailedRetry)
            }
            .buttonStyle(.tomiPrimary)
            .accessibilityIdentifier("load-failed-retry")
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
