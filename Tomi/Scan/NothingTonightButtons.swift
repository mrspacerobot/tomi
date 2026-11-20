import SwiftUI

/// Change what the cook has, or go home.
struct NothingTonightButtons: View {
    let model: ScanModel
    @Binding var path: [HomeRoute]

    var body: some View {
        Button {
            model.stage = .confirming
        } label: {
            Text(.nothingTonightChange)
        }
        .buttonStyle(ShowPrimaryButtonStyle())
        .accessibilityIdentifier("nothing-tonight-change")
        Button {
            path.removeAll()
        } label: {
            Text(.nothingTonightHome).textStyle(.showLede)
        }
        .buttonStyle(.plain)
        .frame(minHeight: TouchTarget.minimum)
    }
}
