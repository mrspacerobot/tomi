import CoreHaptics
import OSLog

/// Plays the custom curtain-call roll. Regular signals use the system feedback presets.
final class ShowHapticPlayer {
    private var engine: CHHapticEngine?
    private let logger = Logger(category: .haptics)

    func playWrap() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            let engine = try activeEngine()
            let player = try engine.makePlayer(with: wrapPattern())
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            logger.debug("The haptic engine could not play the curtain call.")
        }
    }

    private func activeEngine() throws -> CHHapticEngine {
        let active = try engine ?? CHHapticEngine()
        active.playsHapticsOnly = true
        active.isAutoShutdownEnabled = true
        try active.start()
        engine = active
        return active
    }

    private func wrapPattern() throws -> CHHapticPattern {
        let intensities: [Float] = [0.25, 0.4, 0.6, 0.85]
        let taps = intensities.enumerated().map { step, intensity in
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)],
                relativeTime: Double(step) * 0.075
            )
        }
        return try CHHapticPattern(events: taps, parameters: [])
    }
}
