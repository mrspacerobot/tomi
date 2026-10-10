import SwiftUI

/// The first screen of a cook who is not signed in. Tomi keeps the cook's answers on its server,
/// so it asks for Sign in with Apple before anything else.
struct SignInView: View {
    let flow: AppFlowModel

    var body: some View {
        VStack(spacing: Spacing.xLarge) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityLabel(Text(.mascotLabel))
            SignInWords()
            if let problem = flow.problem {
                ProblemView(problem: problem)
            }
            SignInButton(flow: flow)
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    SignInView(flow: .preview())
}
