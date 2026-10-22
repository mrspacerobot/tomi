import CoreGraphics

/// Eye, brow and extra motion, taken from the concept page's keyframes where it has them.
nonisolated enum CompanionFaceTracks {
    static let blink = blink(every: 3.4)
    static let slowBlink = blink(every: 4.2)

    /// Thinking: the glance drifts across the ceiling.
    static let glance = CompanionKeyframes<CGPoint>(
        duration: 3,
        easing: .easeInOut,
        frames: [
            .init(at: 0, value: CompanionPose.thinking.face.eyes.look),
            .init(at: 0.5, value: CGPoint(x: -1, y: -12)),
            .init(at: 1, value: CompanionPose.thinking.face.eyes.look),
        ]
    )

    /// Explaining: brows lift on the stressed word.
    static let accent = CompanionKeyframes<Double>(
        duration: 1.6,
        easing: .easeInOut,
        frames: [
            .init(at: 0, value: -3), .init(at: 0.3, value: -6), .init(at: 0.6, value: -3), .init(at: 1, value: -3),
        ]
    )

    /// One thought dot fading in and out; the three run it a fifth of a second apart.
    static let dot = CompanionKeyframes<Double>(
        duration: 1.2,
        easing: .ease,
        frames: [.init(at: 0, value: 0.15), .init(at: 0.5, value: 1), .init(at: 1, value: 0.15)]
    )

    static let twinkle = CompanionKeyframes<Double>(
        duration: 0.6,
        easing: .easeInOut,
        frames: [.init(at: 0, value: 0.8), .init(at: 0.5, value: 1.25), .init(at: 1, value: 0.8)]
    )

    /// Open, a quick close near the end of the cycle, open again.
    private static func blink(every duration: Double) -> CompanionKeyframes<Double> {
        CompanionKeyframes(
            duration: duration,
            easing: .linear,
            frames: [
                .init(at: 0, value: 1), .init(at: 0.92, value: 1), .init(at: 0.95, value: 0.08), .init(at: 1, value: 1),
            ]
        )
    }
}
