import Foundation
import TomiCore

/// Everything a launch puts together before the first screen: the store, the progress and
/// the services. The launch arguments choose the store and the server, so UI tests never touch the cook's own.
struct AppLaunch {
    let progress: ProgressModel
    /// Nil when this build has no server configured.
    let flow: AppFlowModel?

    init(arguments: [String]) {
        let options = StoreLaunchOptions(arguments: arguments)
        let backend = BackendLaunchOptions(arguments: arguments)
        let store = ProgressStoreOpener.store(for: options)
        let flow = Self.flow(backend, store: store)
        self.flow = flow
        progress = ProgressModel(store: store, server: ProgressServer(flow?.services), clock: .forLaunch(backend))
    }

    private static func flow(_ backend: BackendLaunchOptions, store: any ProgressStore) -> AppFlowModel? {
        guard let services = AppServices.forLaunch(backend, store: store) else {
            return nil
        }
        return AppFlowModel(services: services)
    }
}
