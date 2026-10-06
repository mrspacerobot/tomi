import OSLog

/// Speaks with the first choice, and with the fallback when the first choice cannot, so Tomi is never silent.
/// Every line tries the first choice again, because a failure such as a model not yet loaded can pass.
final class FallbackSpeaker: Speaker {
    nonisolated private static let logger = Logger(category: .voice)
    private let primary: any Speaker
    private let fallback: any Speaker

    init(primary: any Speaker, fallback: any Speaker) {
        self.primary = primary
        self.fallback = fallback
    }

    func speak(_ line: String) async throws {
        do {
            try await primary.speak(line)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            Self.logger.error("The first voice failed: \(String(describing: error), privacy: .public)")
            try await fallback.speak(line)
        }
    }

    func stop() {
        primary.stop()
        fallback.stop()
    }
}
