import Foundation
import OSLog

/// Fake saved data for previews. Nothing is read from the phone and no server is asked.
extension ProgressModel {
    private static let previewLogger = Logger(category: .preview)

    /// A cook with the progress of `KnownState`: its unsent cooks and the fake server's returning snapshot.
    static func previewWithProgress() -> ProgressModel {
        let store = InMemoryProgressStore()
        fill(store, with: KnownState())
        return ProgressModel(store: store, server: .preview, clock: .phone)
    }

    /// A launch on which saved data could not be opened.
    static func previewUnavailable() -> ProgressModel {
        ProgressModel(store: UnavailableProgressStore(), server: .preview, clock: .phone)
    }

    private static func fill(_ store: InMemoryProgressStore, with state: KnownState) {
        do {
            try state.write(to: store)
        } catch {
            previewLogger.error("The preview store could not be filled.")
        }
    }
}
