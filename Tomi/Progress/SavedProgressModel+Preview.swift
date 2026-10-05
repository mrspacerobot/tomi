import Foundation
import OSLog

/// Fake saved data for previews. Nothing is read from the phone.
extension SavedProgressModel {
    private static let previewLogger = Logger(category: .preview)

    /// A cook with the progress of `KnownState`.
    static func previewWithProgress() -> SavedProgressModel {
        let store = InMemoryProgressStore()
        let catalog = BundledLibrary.catalog()
        if let catalog {
            fill(store, with: KnownState(catalog: catalog))
        }
        let reader = ProgressSummaryReader(store: store, catalog: catalog, calendar: .current)
        return SavedProgressModel(reader: reader, now: .now)
    }

    /// A launch on which saved data could not be opened.
    static func previewUnavailable() -> SavedProgressModel {
        let reader = ProgressSummaryReader(store: UnavailableProgressStore(), catalog: nil, calendar: .current)
        return SavedProgressModel(reader: reader, now: .now)
    }

    private static func fill(_ store: InMemoryProgressStore, with state: KnownState) {
        do {
            try state.write(to: store)
        } catch {
            previewLogger.error("The preview store could not be filled.")
        }
    }
}
