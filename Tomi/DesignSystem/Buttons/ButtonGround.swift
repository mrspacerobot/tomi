import SwiftUI

/// The fill and the edge of a button, behind its words.
struct ButtonGround: View {
    let look: ButtonLook

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Radius.button)
        shape
            .fill(fill)
            .overlay(shape.strokeBorder(outline, lineWidth: RuleWeight.outline))
    }

    private var fill: Color {
        guard let role = look.fill else {
            return .clear
        }
        return role.color.opacity(look.fillOpacity)
    }

    private var outline: Color {
        guard let role = look.outline else {
            return .clear
        }
        return role.color
    }
}

#Preview {
    VStack(spacing: Spacing.small) {
        ButtonGround(look: .look(of: .primary, isPressed: false, isEnabled: true))
        ButtonGround(look: .look(of: .secondary, isPressed: true, isEnabled: true))
        ButtonGround(look: .disabled)
    }
    .frame(height: TouchTarget.button * 4)
    .padding()
    .background(ColorRole.paper.color)
}
