#if DEBUG
    import SwiftUI

    struct ShowGalleryTabs: View {
        @State private var selection = ShowGalleryTab.episodeGuide

        var body: some View {
            ShowTabBar(items: ShowGalleryTab.items, selection: $selection)
        }
    }

    #Preview("Morning") { ShowGalleryTabs().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowGalleryTabs().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
