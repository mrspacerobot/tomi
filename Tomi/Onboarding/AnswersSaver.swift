import Foundation
import OSLog
import TomiCore

/// Sends answers to the server, and asks the cook first when the change removes a diet or an avoid item.
@Observable
final class AnswersSaver {
    private static let logger = Logger(category: .backend)

    private(set) var problem: ProblemText?
    private(set) var isSaving = false
    /// True while the screen asks the cook to confirm removing a restriction.
    var isConfirming = false
    private let profile: ProfileModel

    init(profile: ProfileModel) {
        self.profile = profile
    }

    /// Whether the answers are saved. False when the cook must confirm first, or when saving failed.
    func save(_ answers: CookProfile, confirmed: Bool) async -> Bool {
        isSaving = true
        defer { isSaving = false }
        do {
            return show(try await profile.save(answers, confirmedWeaker: confirmed))
        } catch {
            Self.logger.error("Answers were not saved: \(String(describing: error), privacy: .public)")
            problem = ProblemText(error)
            return false
        }
    }

    private func show(_ result: ProfileSaveResult) -> Bool {
        problem = nil
        isConfirming = result == .needsConfirmation
        return result == .saved
    }
}
