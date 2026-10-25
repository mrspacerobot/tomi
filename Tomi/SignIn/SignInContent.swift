import SwiftUI

/// Everything on the sign-in screen, from the mascot down to the Apple button.
struct SignInContent: View {
    let flow: AppFlowModel
    let emailAuth: EmailAuthModel

    var body: some View {
        VStack(spacing: Spacing.xLarge) {
            SignInHeader()
            EmailAuthForm(model: emailAuth)
            SignInChoiceWords()
            if let problem = flow.problem {
                ProblemView(problem: problem)
            }
            SignInButton(flow: flow)
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SignInContent(flow: .preview(), emailAuth: EmailAuthModel(flow: .preview()))
        .background(ColorRole.paper.color)
}
