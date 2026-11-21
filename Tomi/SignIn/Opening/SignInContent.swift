import SwiftUI

struct SignInContent: View {
    let flow: AppFlowModel
    let openEmail: () -> Void

    var body: some View {
        VStack(spacing: ShowSize.rowGap) {
            SignInHeader()
            SignInActions(flow: flow, openEmail: openEmail)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, ShowSize.footer)
    }
}

#Preview {
    SignInContent(flow: .preview(), openEmail: {})
        .background { ShowStage() }
}
