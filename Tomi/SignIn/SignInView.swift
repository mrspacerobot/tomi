import SwiftUI

/// The first screen of a cook who is not signed in. Tomi keeps the cook's answers on its server,
/// so it asks for an email account or Sign in with Apple before anything else.
struct SignInView: View {
    let flow: AppFlowModel
    @State private var emailAuth: EmailAuthModel

    init(flow: AppFlowModel) {
        self.flow = flow
        _emailAuth = State(initialValue: EmailAuthModel(flow: flow))
    }

    var body: some View {
        ScrollView {
            SignInContent(flow: flow, emailAuth: emailAuth)
                .containerRelativeFrame(.vertical, alignment: .center)
        }
        .background(ColorRole.paper.color)
    }
}

#Preview {
    SignInView(flow: .preview())
}
