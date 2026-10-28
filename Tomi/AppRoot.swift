import SwiftUI
import TomiCore

/// The first screen of the app. A debug build opens on the component gallery or the voice try-out instead when it
/// is launched with their argument; a release build contains neither.
struct AppRoot: View {
    let progress: SavedProgressModel
    let flow: AppFlowModel?

    var body: some View {
        #if DEBUG
            if GalleryLaunch.isRequested || CompanionGalleryLaunch.requested {
                ComponentGallery()
            } else if VoiceTryoutLaunch.isRequested {
                VoiceTryoutView(speaker: VoiceService.speaker())
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

#Preview("Largest text") {
    AppRoot(progress: .previewWithProgress(), flow: .preview())
        .dynamicTypeSize(.accessibility5)
}
