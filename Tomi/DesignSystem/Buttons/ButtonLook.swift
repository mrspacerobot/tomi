import CoreGraphics

/// What a button is drawn with in one of its states. Decided here, apart from the view, so a test can hold
/// every state to the contrast rule and to "never by colour alone".
nonisolated struct ButtonLook: Hashable, Sendable {
    /// How much of its fill a pressed primary button keeps, so the ground shows through under the finger.
    static let pressedFillOpacity: CGFloat = 0.8

    let text: ColorRole
    /// Nil when the ground shows through.
    var fill: ColorRole?
    /// Nil when the button has no edge of its own.
    var outline: ColorRole?
    var fillOpacity: CGFloat = 1

    /// A disabled button of either kind: no fill, faded words and a hairline-coloured edge (`.b-btn.off`).
    static let disabled = ButtonLook(text: .inkFaded, outline: .rule)

    static func look(of kind: TomiButtonKind, isPressed: Bool, isEnabled: Bool) -> ButtonLook {
        guard isEnabled else {
            return disabled
        }
        switch kind {
        case .primary: return primary(isPressed: isPressed)
        case .secondary: return secondary(isPressed: isPressed)
        }
    }

    private static func primary(isPressed: Bool) -> ButtonLook {
        var look = ButtonLook(text: .onPrimary, fill: .primaryFill)
        if isPressed {
            look.fillOpacity = pressedFillOpacity
        }
        return look
    }

    /// Pressed, the outline button fills with the wash, the same band a ticked row gets.
    private static func secondary(isPressed: Bool) -> ButtonLook {
        var look = ButtonLook(text: .cobalt, outline: .cobalt)
        if isPressed {
            look.fill = .wash
        }
        return look
    }
}
