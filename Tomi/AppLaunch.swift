import Foundation
import TomiCore

/// Everything a launch puts together before the first screen: the library, the store, the saved progress and
/// the services. The launch arguments choose the store and the server, so UI tests never touch the cook's own.
struct AppLaunch {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel
    /// Nil when this build has no server configured.
    let flow: AppFlowModel?

    init(arguments: [String], now: Date) {
        let catalog = BundledLibrary.catalog()
        let options = StoreLaunchOptions(arguments: arguments)
        let store = ProgressStoreOpener.store(for: options, catalog: catalog)
        let reader = ProgressSummaryReader(store: store, catalog: catalog, calendar: .current)
        self.catalog = catalog
        progress = SavedProgressModel(reader: reader, now: now)
        let services = AppServices.forLaunch(BackendLaunchOptions(arguments: arguments), store: store)
        if let services {
            flow = AppFlowModel(services: services)
        } else {
            flow = nil
        }
    }
}
