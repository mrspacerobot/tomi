import SwiftUI

struct ShowSpeechBubble<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .textStyle(.showText)
            .padding(.horizontal, ShowSize.cardHorizontal)
            .padding(.vertical, ShowSize.cardVertical)
            .background { ShowCardGround(radius: Radius.showButton) }
            .background(alignment: .topLeading) { ShowSpeechBubbleTail() }
    }
}

#Preview("Morning") {
    ShowSpeechBubble { Text(.galleryTitle) }
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowSpeechBubble { Text(.galleryTitle) }
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
