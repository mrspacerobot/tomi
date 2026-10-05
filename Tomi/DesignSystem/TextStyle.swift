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

    var metrics: TextMetrics {
        switch self {
        case .displayXL: TextMetrics(typeface: .gloock, size: 40, lineHeight: 44)
        case .displayL: TextMetrics(typeface: .gloock, size: 34, lineHeight: 38)
        case .displayM: TextMetrics(typeface: .gloock, size: 30, lineHeight: 35)
        case .title: TextMetrics(typeface: .gloock, size: 25, lineHeight: 30)
        case .value: TextMetrics(typeface: .gloock, size: 24, lineHeight: 28)
        case .dish: TextMetrics(typeface: .gloock, size: 19, lineHeight: 24)
        case .option: TextMetrics(typeface: .gloock, size: 22, lineHeight: 28)
        case .timer: TextMetrics(typeface: .gloock, size: 40, lineHeight: 44)
        case .step: TextMetrics(typeface: .newsreaderMedium, size: 22, lineHeight: 30)
        case .stepKeyPhrase: TextMetrics(typeface: .newsreaderSemiBoldItalic, size: 22, lineHeight: 30)
        case .body: TextMetrics(typeface: .newsreader, size: 17, lineHeight: 23)
        case .description: TextMetrics(typeface: .newsreaderItalic, size: 15, lineHeight: 20)
        case .label: TextMetrics(typeface: .figtreeBold, size: 11, lineHeight: 14)
        case .button: TextMetrics(typeface: .figtreeSemiBold, size: 16.5, lineHeight: 20)
        case .status: TextMetrics(typeface: .figtreeSemiBold, size: 13, lineHeight: 24)
        case .chip: TextMetrics(typeface: .figtreeSemiBold, size: 15.5, lineHeight: 20)
        case .tag: TextMetrics(typeface: .figtreeSemiBold, size: 13, lineHeight: 16)
        case .caption: TextMetrics(typeface: .figtreeMedium, size: 12, lineHeight: 15)
        }
    }
}
