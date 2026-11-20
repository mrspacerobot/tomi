/// The named text styles of the Cooking Show handoff.
/// Apply one with `textStyle(_:)`; sizes grow and shrink with the cook's text size.
nonisolated enum TextStyle: CaseIterable, Sendable {
    case marquee
    case marqueeKicker
    case showTitle
    case showStat
    case showButton
    case answerKey
    case cardTitle
    case lowerThird
    case showBodyStrong
    case showBody
    case showText
    case showLede
    case showNote
    case showMeta
    case showLabel
    case showPill
    case showTag
    case showGlyph
}
