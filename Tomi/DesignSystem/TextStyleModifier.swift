import SwiftUI

/// Sets text in a named style. Size, line height and letter spacing all follow the cook's text size.
struct TextStyleModifier: ViewModifier {
    let style: TextStyle
    let color: ColorRole
    @ScaledMetric private var size: CGFloat
    @ScaledMetric private var lineHeight: CGFloat

    init(style: TextStyle, color: ColorRole) {
        self.style = style
        self.color = color
        _size = ScaledMetric(wrappedValue: style.metrics.size, relativeTo: style.scalesWith)
        _lineHeight = ScaledMetric(wrappedValue: style.metrics.lineHeight, relativeTo: style.scalesWith)
    }

    func body(content: Content) -> some View {
        content
            .font(style.font(size: size))
            .lineHeight(.exact(points: lineHeight))
            .tracking(style.trackingInEm * size)
            .textCase(style.textCase)
            .foregroundStyle(color.color)
    }
}
