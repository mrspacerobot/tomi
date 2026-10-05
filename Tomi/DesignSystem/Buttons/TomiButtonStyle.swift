import SwiftUI

/// The primary and the secondary button of the design. Use it on a plain `Button`, so the button keeps its
/// VoiceOver name, its trait and its disabled state:
/// `Button(action: start) { Text(.startCooking) }.buttonStyle(.tomiPrimary)`.
struct TomiButtonStyle: ButtonStyle {
    let kind: TomiButtonKind

    func makeBody(configuration: Configuration) -> some View {
        ButtonFace(kind: kind, isPressed: configuration.isPressed) {
            configuration.label
        }
    }
}

#Preview("Light") {
    VStack(spacing: Spacing.small) {
        Button(action: {}, label: { Text(.sampleButtonPrimary) })
            .buttonStyle(.tomiPrimary)
        Button(action: {}, label: { Text(.sampleButtonSecondary) })
            .buttonStyle(.tomiSecondary)
    }
    .padding()
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text") {
    VStack(spacing: Spacing.small) {
        Button(action: {}, label: { Text(.sampleBoxScan) })
            .buttonStyle(.tomiPrimary)
        Button(action: {}, label: { Text(.sampleBoxType) })
            .buttonStyle(.tomiSecondary)
    }
    .padding()
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
