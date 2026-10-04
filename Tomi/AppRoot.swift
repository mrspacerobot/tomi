import SwiftUI
import TomiCore

/// The first screen of the app. A debug build opens on the component gallery instead when it is launched
/// with the gallery's argument; a release build does not contain the gallery at all.
struct AppRoot: View {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel

    var body: some View {
        #if DEBUG
            if GalleryLaunch.isRequested {
                ComponentGallery()
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
