import SwiftUI

/// The server had no dish the cook can cook yet, which is normal early on: Tomi says so kindly.
struct NothingTonightView: View {
    let model: ScanModel
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(spacing: Spacing.large) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityHidden(true)
            Text(.nothingTonightTitle)
                .textStyle(.title)
                .accessibilityIdentifier("nothing-tonight-title")
            Text(.nothingTonightMessage)
                .textStyle(.body)
            Button { model.stage = .confirming } label: { Text(.nothingTonightChange) }
                .buttonStyle(.tomiPrimary)
                .accessibilityIdentifier("nothing-tonight-change")
            Button { path.removeAll() } label: { Text(.nothingTonightHome) }
                .buttonStyle(.tomiSecondary)
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.screenMargin)
    }
}

#Preview {
    NothingTonightView(model: .preview(), path: .constant([]))
        .background(ColorRole.paper.color)
}
