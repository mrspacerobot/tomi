import SwiftUI

struct ShowTabGlyph: View {
    let icon: ShowTabIcon

    var body: some View {
        switch icon {
        case .symbol(let name):
            Image(systemName: name).font(.system(size: ShowSize.tabIcon, weight: .semibold))
        case .host:
            TomiHostHead().frame(width: MascotSize.showHead, height: MascotSize.showHead)
        }
    }
}

#if DEBUG
    #Preview("Morning") { ShowGalleryTabs().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowGalleryTabs().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
