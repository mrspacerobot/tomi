import SwiftUI

/// Opening titles, or the backstage pass when the cook chooses email.
struct SignInView: View {
    let flow: AppFlowModel
    @State private var emailAuth: EmailAuthModel
    @State private var showsEmail = false

    init(flow: AppFlowModel) {
        self.flow = flow
        _emailAuth = State(initialValue: EmailAuthModel(flow: flow))
    }

    var body: some View {
        ScrollView {
            if showsEmail {
                EmailAuthPage(model: emailAuth, back: closeEmail)
            } else {
                SignInContent(flow: flow, openEmail: { showsEmail = true })
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background { ShowStage() }
    }

    private func closeEmail() {
        emailAuth.choose(.signIn)
        showsEmail = false
    }
}

#Preview("Morning") { SignInView(flow: .preview()).preferredColorScheme(.light) }
#Preview("Evening, largest text") {
    SignInView(flow: .preview()).preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
