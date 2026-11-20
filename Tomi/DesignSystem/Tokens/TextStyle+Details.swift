import SwiftUI

nonisolated extension TextStyle {
    /// The colour the style is set in unless the caller names another. Always one of `ColorRole.textRoles`.
    var defaultColor: ColorRole {
        switch self {
        case .description, .label, .caption: .inkFaded
        case .marquee, .showButton, .answerKey: .showWhite
        case .marqueeKicker: .showBulb
        case .showNote, .showMeta: .showMuted
        case .showTitle, .showLede: .stageInk
        case .showLabel: .stageGold
        case .showStat, .cardTitle, .lowerThird, .showBodyStrong, .showBody, .showText, .showPill, .showTag, .showGlyph:
            .showInk
        default: .ink
        }
    }

    /// Extra space between letters, as a share of the font size, so it grows with the text.
    var trackingInEm: CGFloat {
        switch self {
        case .label, .showLabel: 0.14
        case .marqueeKicker: 0.24
        case .showButton: 0.01
        default: 0
        }
    }

    /// Casing is styling: the catalog stores "Chez Tomi" and the label style shows it in capitals.
    var textCase: Text.Case? {
        switch self {
        case .label, .showLabel, .marqueeKicker: .uppercase
        default: nil
        }
    }

    /// The system text style whose growth this style follows when the cook changes the text size.
    var scalesWith: Font.TextStyle {
        switch self {
        case .displayXL, .displayL, .displayM, .timer, .marquee: .largeTitle
        case .title, .value, .showTitle, .showStat: .title
        case .dish, .option, .step, .stepKeyPhrase, .cardTitle, .showBodyStrong: .title3
        case .body, .button, .showButton, .showBody, .answerKey: .body
        case .chip, .showText, .showLede: .callout
        case .description, .showNote: .subheadline
        case .status, .tag, .lowerThird, .showPill, .showGlyph: .footnote
        case .caption, .showMeta, .showTag: .caption
        case .label, .showLabel, .marqueeKicker: .caption2
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
