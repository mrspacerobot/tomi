import SwiftUI

struct SignInActions: View {
    let flow: AppFlowModel
    let openEmail: () -> Void

    var body: some View {
        VStack(spacing: ShowSize.gap) {
            if let problem = flow.problem {
                ProblemView(problem: problem)
            }
            SignInButton(flow: flow)
            SignInChoiceWords(action: openEmail)
        }
        .padding(.horizontal, ShowSize.controlEdge)
    }
}

#Preview {
    SignInActions(flow: .preview(), openEmail: {}).background { ShowStage() }
}
