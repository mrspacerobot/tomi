import SwiftUI

struct ShowSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(.showLede)
            .multilineTextAlignment(.center)
            .underline(configuration.isPressed)
            .frame(minWidth: TouchTarget.minimum, minHeight: TouchTarget.minimum)
            .contentShape(.interaction, Rectangle())
            .opacity(opacity)
    }

    private var opacity: Double {
        if isEnabled { return 1 }
        return 0.55
    }
}

#Preview { Button(.onboardingBack) {}.buttonStyle(ShowSecondaryButtonStyle()).background { ShowStage() } }
