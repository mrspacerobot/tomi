import Foundation
import TomiCore

/// Everything a launch puts together before the first screen: the library, the store and the saved progress.
/// The launch arguments choose the store, so UI tests never touch the cook's own.
struct AppLaunch {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel

    init(arguments: [String], now: Date) {
        let catalog = BundledLibrary.catalog()
        let options = StoreLaunchOptions(arguments: arguments)
        let store = ProgressStoreOpener.store(for: options, catalog: catalog)
        let reader = ProgressSummaryReader(store: store, catalog: catalog, calendar: .current)
        self.catalog = catalog
        self.progress = SavedProgressModel(reader: reader, now: now)
    }
}
