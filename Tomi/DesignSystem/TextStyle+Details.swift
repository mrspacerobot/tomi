import SwiftUI

nonisolated extension TextStyle {
    /// The colour the style is set in unless the caller names another. Always one of `ColorRole.textRoles`.
    var defaultColor: ColorRole {
        switch self {
        case .description, .label: .inkFaded
        default: .ink
        }
    }

    /// Extra space between letters, as a share of the font size, so it grows with the text.
    var trackingInEm: CGFloat {
        if self == .label {
            return 0.14
        }
        return 0
    }

    /// Casing is styling: the catalog stores "Chez Tomi" and the label style shows it in capitals.
    var textCase: Text.Case? {
        if self == .label {
            return .uppercase
        }
        return nil
    }

    /// The system text style whose growth this style follows when the cook changes the text size.
    var scalesWith: Font.TextStyle {
        switch self {
        case .displayXL, .displayL, .displayM, .timer: .largeTitle
        case .title, .value: .title
        case .dish, .step, .stepKeyPhrase: .title3
        case .body, .button: .body
        case .chip: .callout
        case .description: .subheadline
        case .status: .footnote
        case .label: .caption2
        }
    }

    /// The bundled font of the style at a size that has already been scaled to the cook's text size.
    func font(size: CGFloat) -> Font {
        let font = Font.custom(metrics.typeface.fontName, fixedSize: size)
        if self == .timer {
            return font.monospacedDigit()
        }
        return font
    }
}
