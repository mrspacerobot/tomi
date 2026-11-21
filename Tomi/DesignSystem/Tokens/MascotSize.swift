import CoreGraphics

/// The sizes Tomi is drawn at, in points: the frame his figure fills at rest, toque to shoes, as drawn in the
/// mockups of `docs/design`. A jump, thought dots or sparkles may spill past it.
nonisolated enum MascotSize {
    /// The drawn head in a Cooking Show tab, and the two portrait scales for the host gallery.
    static let showHead: CGFloat = 43
    static let showHostPortrait: CGFloat = 98
    static let showHostTile: CGFloat = 132

    /// The companion stage in the gallery.
    static let companion: CGFloat = 240
    /// The printed Tomi on the home masthead (`round2.html`, `home-empty`).
    static let home: CGFloat = 66

    /// The animated companion on the welcome screen of onboarding (`round2.html`, `ob-welcome`).
    static let companionWelcome: CGFloat = 174
    /// The tinted disc behind him on the welcome screen.
    static let welcomeDisc: CGFloat = 232
    /// The animated companion beside a line Tomi says, as on the diet question (`round2.html`, `ob-diet`).
    static let companionGreeting: CGFloat = 89

    /// The printed mascot on sign-in, home and the starting screen, as large as on the welcome.
    static let welcome: CGFloat = 174
    /// The printed mascot beside a short notice, as when there is nothing to cook (`round2.html`, `scan-nothing`).
    static let notice: CGFloat = 106
}
