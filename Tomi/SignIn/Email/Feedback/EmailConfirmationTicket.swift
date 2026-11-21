import SwiftUI

struct EmailConfirmationTicket: View {
    let model: EmailAuthModel

    var body: some View {
        VStack(spacing: ShowSize.rowGap) {
            EmailTicketFace(email: model.cleanEmail)
            EmailAuthPortrait(hasProblem: false)
            Text(.openingCheckEmail).textStyle(.showTitle).accessibilityAddTraits(.isHeader)
            Text(.openingConfirmationBody(model.cleanEmail))
                .textStyle(.showLede)
                .accessibilityIdentifier("auth-confirmation-message")
            Button(.authSignIn) { model.choose(.signIn) }.buttonStyle(ShowPrimaryButtonStyle())
        }
        .multilineTextAlignment(.center)
    }
}

#Preview { EmailConfirmationTicket(model: EmailAuthModel(flow: .preview())).background { ShowStage() } }
