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
        .buttonStyle(.tomiPrimary)
        .accessibilityIdentifier("nothing-tonight-change")
        Button {
            path.removeAll()
        } label: {
            Text(.nothingTonightHome)
        }
        .buttonStyle(.tomiSecondary)
    }
}
