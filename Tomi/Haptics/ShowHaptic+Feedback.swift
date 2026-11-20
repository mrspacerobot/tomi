import SwiftUI

extension ShowHaptic {
    var feedback: SensoryFeedback? {
        switch self {
        case .selection: .selection
        case .correctAnswer: .success
        case .retryAnswer: .impact(flexibility: .soft, intensity: 0.55)
        case .timerTap: .impact(flexibility: .soft, intensity: 0.75)
        case .scoreTick(let intensity): .impact(flexibility: .soft, intensity: min(max(intensity, 0), 1))
        case .levelUnlocked: .impact(flexibility: .rigid, intensity: 1)
        case .wrap: nil
        }
    }
}
