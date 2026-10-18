import Foundation

/// Whole-body motion, taken from the concept page's keyframes (`docs/design/companion-directions.html`).
nonisolated enum CompanionBodyTracks {
    /// Idle: squash, stretch into a hop, land with a squash, settle, rest.
    static let hop = CompanionKeyframes<CompanionBodyPose>(
        duration: 1.6,
        easing: .bounce,
        frames: [
            .init(at: 0, value: .rest),
            .init(at: 0.12, value: CompanionBodyPose(lift: 2, stretchX: 1.07, stretchY: 0.92)),
            .init(at: 0.30, value: CompanionBodyPose(lift: -16, stretchX: 0.94, stretchY: 1.08)),
            .init(at: 0.46, value: CompanionBodyPose(lift: 0, stretchX: 1.05, stretchY: 0.95)),
            .init(at: 0.56, value: .rest),
            .init(at: 1, value: .rest),
        ]
    )

    /// Celebrating: a deep squash, a big jump with a twist, a landing squash.
    static let pop = CompanionKeyframes<CompanionBodyPose>(
        duration: 1.2,
        easing: .pop,
        frames: [
            .init(at: 0, value: .rest),
            .init(at: 0.2, value: CompanionBodyPose(lift: 4, stretchX: 1.12, stretchY: 0.86)),
            .init(at: 0.45, value: CompanionBodyPose(lift: -30, stretchX: 0.9, stretchY: 1.12, tilt: -4)),
            .init(at: 0.7, value: CompanionBodyPose(lift: 0, stretchX: 1.08, stretchY: 0.93)),
            .init(at: 1, value: .rest),
        ]
    )

    /// Listening: leans in a little further and back, like nodding along.
    static let lean = CompanionKeyframes<CompanionBodyPose>(
        duration: 2.4,
        easing: .easeInOut,
        frames: [
            .init(at: 0, value: CompanionPose.listening.body),
            .init(at: 0.5, value: CompanionBodyPose(lift: -2, stretchX: 0.98, stretchY: 1.02, tilt: -9)),
            .init(at: 1, value: CompanionPose.listening.body),
        ]
    )

    /// Explaining: a small bob on each beat of speech.
    static let bob = CompanionKeyframes<CompanionBodyPose>(
        duration: 0.8,
        easing: .ease,
        frames: [
            .init(at: 0, value: CompanionPose.explaining.body),
            .init(at: 0.15, value: CompanionBodyPose(lift: 1, stretchX: 1.03, stretchY: 0.97, tilt: -2)),
            .init(at: 0.4, value: CompanionBodyPose(lift: -5, stretchX: 0.98, stretchY: 1.03, tilt: -3)),
            .init(at: 0.65, value: CompanionPose.explaining.body),
            .init(at: 1, value: CompanionPose.explaining.body),
        ]
    )
}
