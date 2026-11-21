import SwiftUI

struct EmailAuthPage: View {
    let model: EmailAuthModel
    let back: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.rowGap) {
            EmailAuthHeader(back: back).disabled(model.isSubmitting)
            if model.needsConfirmation {
                EmailConfirmationTicket(model: model)
            } else {
                EmailAuthForm(model: model)
            }
        }
        .padding(ShowSize.controlEdge)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    EmailAuthPage(model: EmailAuthModel(flow: .preview()), back: {}).background { ShowStage() }
}
