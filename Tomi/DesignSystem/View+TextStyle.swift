import SwiftUI

extension View {
    /// Sets text in a named style and that style's own colour.
    func textStyle(_ style: TextStyle) -> some View {
        modifier(TextStyleModifier(style: style, color: style.defaultColor))
    }

    /// Sets text in a named style and another colour, such as a kicker in cobalt.
    func textStyle(_ style: TextStyle, color: ColorRole) -> some View {
        modifier(TextStyleModifier(style: style, color: color))
    }
}
