import Foundation

/// Seconds of motion so far, counted only between frames that both move. Time while motion is stopped
/// (scene inactive, view hidden, Reduce Motion) does not count, so Tomi resumes where he stopped. A frame
/// dated before the last never runs time backwards, and one late frame adds at most `longestStep`.
nonisolated struct CompanionElapsed {
    static let longestStep = 1.0

    private(set) var seconds = 0.0
    private var lastMovingFrame: Date?

    mutating func advance(to frame: Date, moving: Bool) -> Double {
        guard moving else {
            lastMovingFrame = nil
            return seconds
        }
        if let lastMovingFrame {
            seconds += step(from: lastMovingFrame, to: frame)
        }
        lastMovingFrame = frame
        return seconds
    }

    private func step(from previous: Date, to frame: Date) -> Double {
        let gap = frame.timeIntervalSince(previous)
        return min(max(gap, 0), Self.longestStep)
    }
}
