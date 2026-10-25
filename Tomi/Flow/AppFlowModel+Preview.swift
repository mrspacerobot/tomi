import Foundation

/// Fake flows for previews. Nothing reaches the network or the phone's store.
extension AppFlowModel {
    static func preview() -> AppFlowModel {
        AppFlowModel(services: .fake(library: BundledLessonLibrary(), store: InMemoryProgressStore()))
    }
}
