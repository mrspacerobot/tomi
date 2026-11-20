import SwiftUI

struct EmailTicketFace: View {
    let email: String

    var body: some View {
        VStack(spacing: ShowSize.compact) {
            Text(.openingTicketVIP).textStyle(.showLabel, color: .showInk)
            Text(.openingTicketTitle).textStyle(.showStat)
            Text(verbatim: email).textStyle(.showMeta, color: .showInk)
        }
        .padding(ShowSize.cardHorizontal)
        .frame(maxWidth: .infinity)
        .background(ColorRole.showGold.color, in: .rect(cornerRadius: Radius.showCard))
    }
}

#Preview { EmailTicketFace(email: "cook@example.com") }
