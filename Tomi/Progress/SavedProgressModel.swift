import Foundation
import OSLog
import Observation

/// The cook's progress as the screens see it, read from saved data.
@Observable
final class SavedProgressModel {
    private static let logger = Logger(category: .progress)

    /// Nil when saved data cannot be read. Nothing that depends on the cook's answers may be shown then,
    /// because the answers Tomi would fall back on say the cook eats everything.
    private(set) var summary: ProgressSummary?
    private let reader: ProgressSummaryReader

    init(reader: ProgressSummaryReader, now: Date) {
        self.reader = reader
        refresh(at: now)
    }

    func refresh(at now: Date) {
        do {
            summary = try reader.summary(at: now)
        } catch {
            Self.logger.error("Saved data could not be read: \(String(describing: error), privacy: .public)")
            summary = nil
        }
    }
}
