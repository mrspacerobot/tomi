import Foundation
import TomiCore

/// Everything a launch puts together before the first screen: the library, the store, the progress and
/// the services. The launch arguments choose the store and the server, so UI tests never touch the cook's own.
struct AppLaunch {
    let catalog: SkillCatalog?
    let progress: ProgressModel
    /// Nil when this build has no server configured.
    let flow: AppFlowModel?

    init(arguments: [String]) {
        let catalog = BundledLibrary.catalog()
        let options = StoreLaunchOptions(arguments: arguments)
        let store = ProgressStoreOpener.store(for: options, catalog: catalog)
        let flow = Self.flow(arguments: arguments, store: store)
        self.catalog = catalog
        self.flow = flow
        progress = ProgressModel(store: store, api: flow?.services.api, clock: .phone)
    }

    private static func flow(arguments: [String], store: any ProgressStore) -> AppFlowModel? {
        guard let services = AppServices.forLaunch(BackendLaunchOptions(arguments: arguments), store: store) else {
            return nil
        }
        return AppFlowModel(services: services)
    }
}
