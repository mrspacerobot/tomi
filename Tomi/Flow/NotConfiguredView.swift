import SwiftUI

/// Shown instead of the app when this build has no server address: a developer forgot the build settings.
struct NotConfiguredView: View {
    var body: some View {
        ProblemView(problem: ProblemText(BackendError.notConfigured))
            .multilineTextAlignment(.center)
            .padding(Spacing.xLarge)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorRole.paper.color)
    }
}

#Preview {
    NotConfiguredView()
}
