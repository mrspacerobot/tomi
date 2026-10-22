import Foundation

/// Arm swings about the shoulder, in degrees added to the still pose. Positive turns clockwise on screen.
nonisolated enum CompanionSwingTracks {
    static let wave = CompanionKeyframes<Double>(
        duration: 1.1,
        easing: .easeInOut,
        frames: [
            .init(at: 0, value: 0), .init(at: 0.25, value: -28), .init(at: 0.5, value: 8),
            .init(at: 0.75, value: -22), .init(at: 1, value: 0),
        ]
    )

    static let tap = CompanionKeyframes<Double>(
        duration: 0.9,
        easing: .easeInOut,
        frames: [.init(at: 0, value: 0), .init(at: 0.5, value: -8), .init(at: 1, value: 0)]
    )

    static let cup = CompanionKeyframes<Double>(
        duration: 2.4,
        easing: .easeInOut,
        frames: [.init(at: 0, value: 0), .init(at: 0.5, value: 6), .init(at: 1, value: 0)]
    )

    /// An open-handed gesture: the hand lifts, dips past rest, and settles. The right arm mirrors it.
    static let gesture = CompanionKeyframes<Double>(
        duration: 1.6,
        easing: .easeInOut,
        frames: [
            .init(at: 0, value: 0), .init(at: 0.3, value: 14), .init(at: 0.65, value: -5), .init(at: 1, value: 0),
        ]
    )

    static let cheer = CompanionKeyframes<Double>(
        duration: 0.6,
        easing: .easeInOut,
        frames: [.init(at: 0, value: 0), .init(at: 0.5, value: 9), .init(at: 1, value: 0)]
    )
}
