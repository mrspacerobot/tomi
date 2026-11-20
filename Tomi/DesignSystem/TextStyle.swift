/// The named text styles of the design (the type table of the handoff in `docs/design/round3.html`).
/// Apply one with `textStyle(_:)`; sizes grow and shrink with the cook's text size.
nonisolated enum TextStyle: CaseIterable, Sendable {
    /// Welcome and celebration.
    case displayXL
    /// Question and screen titles.
    case displayL
    /// Lesson and quiz titles.
    case displayM
    /// Tonight's special and sheet titles.
    case title
    /// Stats values and rank names.
    case value
    /// Dish lines.
    case dish
    /// The answers on tick rows, which the handoff sets larger than a dish line ("20 to 22 on onboarding").
    case option
    /// Timer digits, each as wide as the next so a running timer does not jitter.
    case timer
    /// Step text.
    case step
    /// The key phrase inside a step.
    case stepKeyPhrase
    /// Explanations and answers.
    case body
    /// Dish descriptions and hints.
    case description
    /// Kickers and column heads, set in capitals.
    case label
    /// Buttons.
    case button
    /// Dish state and values.
    case status
    /// Chips.
    case chip
    /// Use tags, the small chips that name what a dish uses (the handoff's "13 on use tags").
    case tag
    /// The small line under a stats value (`.b-house .s` in the design kit).
    case caption

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
