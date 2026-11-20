import SwiftUI

struct ShowPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(.showButton)
            .multilineTextAlignment(.center)
            .padding(ShowSize.controlPadding)
            .frame(maxWidth: .infinity, minHeight: TouchTarget.minimum)
            .background { ShowButtonGround(pressed: configuration.isPressed && !reduceMotion) }
            .padding(.bottom, ShowSize.buttonLip)
            .opacity(opacity(pressed: configuration.isPressed))
    }

    private func opacity(pressed: Bool) -> Double {
        guard isEnabled else { return 0.55 }
        if pressed && reduceMotion { return 0.8 }
        return 1
    }
}
