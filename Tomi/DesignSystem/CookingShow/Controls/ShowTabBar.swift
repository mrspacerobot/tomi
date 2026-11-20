import SwiftUI

/// An icon bar. The owning screen decides where selection navigates.
struct ShowTabBar<Tab: Hashable>: View {
    let items: [ShowTabItem<Tab>]
    @Binding var selection: Tab

    var body: some View {
        HStack(spacing: ShowSize.compact) {
            ForEach(items) { item in
                ShowTabButton(item: item, selection: $selection)
            }
        }
        .padding(.horizontal, ShowSize.compact)
        .frame(minHeight: ShowSize.tabHeight)
        .background { ShowCardGround(radius: Radius.showCard) }
    }
}

#if DEBUG
    #Preview("Morning") { ShowGalleryTabs().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowGalleryTabs().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
