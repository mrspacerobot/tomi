import SwiftUI

/// The same light card surface in both appearances. Use show ink for content on this surface.
struct ShowCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(.horizontal, ShowSize.cardHorizontal)
            .padding(.vertical, ShowSize.cardVertical)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .center) { ShowCardGround(radius: Radius.showCard) }
    }
}

#Preview("Morning") {
    ShowCard { Text(.galleryTitle).textStyle(.cardTitle) }
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowCard { Text(.galleryTitle).textStyle(.cardTitle) }
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
