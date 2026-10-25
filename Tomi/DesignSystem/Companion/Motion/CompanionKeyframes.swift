import Foundation

/// A repeating keyframe track sampled from elapsed seconds. The easing applies between each pair of keyframes,
/// as a CSS animation does. The frames must start at 0, end at 1 and rise in between.
nonisolated struct CompanionKeyframes<Value: CompanionBlendable>: Sendable {
    let duration: Double
    let easing: CompanionEasing
    let frames: [CompanionKeyframe<Value>]

    func value(at elapsed: Double, delay: Double = 0) -> Value {
        let progress = cycleProgress(at: elapsed - delay)
        let index = segmentStart(for: progress)
        let start = frames[index]
        let end = frames[index + 1]
        let local = (progress - start.at) / (end.at - start.at)
        return start.value.blended(toward: end.value, by: easing.value(at: local))
    }

    private func cycleProgress(at elapsed: Double) -> Double {
        var remainder = elapsed.truncatingRemainder(dividingBy: duration)
        if remainder < 0 {
            remainder += duration
        }
        return remainder / duration
    }

    private func segmentStart(for progress: Double) -> Int {
        var index = 0
        while index + 2 < frames.count && frames[index + 1].at <= progress {
            index += 1
        }
        return index
    }
}
