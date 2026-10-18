import CoreGraphics

/// The sizes Tomi is drawn at, in points.
nonisolated enum MascotSize {
    /// The companion stage in the gallery.
    static let companion: CGFloat = 280

    /// The animated companion on the welcome screen of onboarding.
    static let companionWelcome: CGFloat = 200
    /// The animated companion beside a line Tomi says, as on the diet question of onboarding.
    static let companionGreeting: CGFloat = 96

    /// The printed mascot on sign-in, home and the other full screens.
    static let welcome: CGFloat = 164
}
