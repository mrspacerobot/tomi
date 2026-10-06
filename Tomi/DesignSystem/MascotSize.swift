import CoreGraphics

/// The sizes Tomi is drawn at, in points.
nonisolated enum MascotSize {
    /// The interactive companion stage in the gallery.
    static let companion: CGFloat = 280

    /// The animated companion on the welcome screen of onboarding.
    static let companionWelcome: CGFloat = 200
    /// The animated companion beside a line Tomi says, as on the diet question of onboarding.
    static let companionGreeting: CGFloat = 96

    /// On the welcome screen.
    static let welcome: CGFloat = 164
    /// Beside a line Tomi says, as on the diet question of onboarding.
    static let greeting: CGFloat = 56
}
