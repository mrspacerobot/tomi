import SwiftUI
import TomiCore

/// The first screen of the app. A debug build opens on the component gallery instead when it is launched
/// with the gallery's argument; a release build does not contain the gallery at all.
struct AppRoot: View {
    let progress: ProgressModel
    let flow: AppFlowModel?

    var body: some View {
        #if DEBUG
            if ProcessInfo.processInfo.arguments.contains(ShowHostGallery.launchArgument) {
                ShowHostGallery()
            } else if ProcessInfo.processInfo.arguments.contains(ShowGallery.launchArgument) {
                ShowGallery()
            } else if GalleryLaunch.isRequested || CompanionGalleryLaunch.requested {
                ComponentGallery()
            } else {
                RootView(progress: progress, flow: flow)
            }
        #else
            RootView(progress: progress, flow: flow)
        #endif
    }
}

#Preview {
    AppRoot(progress: .previewWithProgress(), flow: .preview())
}
