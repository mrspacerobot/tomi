import Foundation

/// Mouth shapes cycled while Tomi speaks. They are not lip sync: no audio is read, the cycle only reads as talk.
nonisolated enum CompanionSpeech {
    static let beat = 0.13

    static let mouths: [CompanionMouth] = [
        CompanionMouth(shape: .grin, width: 21, open: 0.5),
        CompanionMouth(shape: .round, width: 9, open: 12),
        CompanionMouth(shape: .grin, width: 19, open: 0.15),
        CompanionMouth(shape: .grin, width: 23, open: 0.8),
        CompanionMouth(shape: .round, width: 7, open: 8),
        CompanionMouth(shape: .grin, width: 18, open: -0.2),
        CompanionMouth(shape: .grin, width: 22, open: 0.6),
        CompanionMouth(shape: .round, width: 10, open: 10),
    ]

    static func mouth(at elapsed: Double) -> CompanionMouth {
        let beats = Int((elapsed / beat).rounded(.down))
        var index = beats % mouths.count
        if index < 0 {
            index += mouths.count
        }
        return mouths[index]
    }
}
