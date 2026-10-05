import SwiftUI
import TomiCore

/// The first screen of the app. A debug build opens on the component gallery or the voice try-out instead when it
/// is launched with their argument; a release build contains neither.
struct AppRoot: View {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel

    var body: some View {
        #if DEBUG
            if GalleryLaunch.isRequested {
                ComponentGallery()
            } else if VoiceTryoutLaunch.isRequested {
                VoiceTryoutView(speaker: VoiceService.speaker())
            } else {
                RootView(catalog: catalog, progress: progress)
            }
        #else
            RootView(catalog: catalog, progress: progress)
        #endif
    }
}

#Preview {
    AppRoot(catalog: BundledLibrary.catalog(), progress: .previewWithProgress())
}

#Preview("Largest text") {
    AppRoot(catalog: BundledLibrary.catalog(), progress: .previewWithProgress())
        .dynamicTypeSize(.accessibility5)
}
