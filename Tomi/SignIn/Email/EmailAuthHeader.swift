import SwiftUI

struct EmailAuthHeader: View {
    let back: () -> Void

    var body: some View {
        HStack(spacing: ShowSize.gap) {
            ShowBackButton(action: back)
                .accessibilityIdentifier("close-email-auth")
            ShowLowerThird(title: .openingBackstagePass)
        }
    }
}

#Preview { EmailAuthHeader(back: {}).background { ShowStage() } }
