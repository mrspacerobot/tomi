import SwiftUI

/// How a button looks: its words, a drawing before them if there is one, and its ground. `TomiButtonStyle`
/// draws every button with it; shown by itself it is a picture of a state, such as pressed.
struct ButtonFace<Label: View>: View {
    let kind: TomiButtonKind
    let isPressed: Bool
    @ViewBuilder let label: Label
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        let look = ButtonLook.look(of: kind, isPressed: isPressed, isEnabled: isEnabled)
        HStack(spacing: Spacing.xSmall) {
            label
        }
        .textStyle(.button, color: look.text)
        .multilineTextAlignment(.center)
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.xSmall)
        .frame(maxWidth: .infinity, minHeight: TouchTarget.button)
        .background(ButtonGround(look: look))
        .contentShape(.rect)
    }
}

#Preview("Pressed") {
    VStack(spacing: Spacing.small) {
        ForEach(TomiButtonKind.allCases, id: \.self) { kind in
            ButtonFace(kind: kind, isPressed: true) {
                Icon(.camera, size: .medium)
                Text(.galleryStatePressed)
            }
        }
    }
    .padding()
    .background(ColorRole.paper.color)
}

#Preview("Disabled") {
    ButtonFace(kind: .primary, isPressed: false) {
        Text(.galleryStateDisabled)
    }
    .disabled(true)
    .padding()
    .background(ColorRole.paper.color)
}
