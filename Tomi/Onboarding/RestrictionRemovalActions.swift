import SwiftUI

struct RestrictionRemovalActions: View {
    let cancel: () -> Void
    let confirm: () -> Void

    var body: some View {
        Button(.confirmRemovalNo, action: cancel).buttonStyle(ShowPrimaryButtonStyle())
        Button(role: .destructive, action: confirm) {
            Text(.confirmRemovalYes).textStyle(.showLede)
        }
        .buttonStyle(.plain)
        .frame(minHeight: TouchTarget.minimum)
        .accessibilityIdentifier("confirm-removal-yes")
    }
}

#Preview { RestrictionRemovalActions(cancel: {}, confirm: {}).background { ShowStage() } }
