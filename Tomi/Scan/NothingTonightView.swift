import SwiftUI

/// The server had no dish the cook can cook yet, which is normal early on: Tomi says so kindly.
struct NothingTonightView: View {
    let model: ScanModel
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(spacing: Spacing.large) {
            TomiMascot(mood: .thinking)
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityHidden(true)
            Text(.nothingTonightTitle)
                .textStyle(.title)
                .accessibilityIdentifier("nothing-tonight-title")
            Text(.nothingTonightMessage)
                .textStyle(.body)
            NothingTonightButtons(model: model, path: $path)
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.screenMargin)
    }
}

#Preview {
    NothingTonightView(model: .preview(), path: .constant([]))
        .background(ColorRole.paper.color)
}
