import SwiftUI

struct ShowSpeechBubbleTail: View {
    var body: some View {
        Image(systemName: "triangle.fill")
            .rotationEffect(.degrees(-90))
            .foregroundStyle(ColorRole.showSurface.color)
            .offset(x: -ShowSize.gap, y: ShowSize.cardVertical)
            .accessibilityHidden(true)
    }
}

#Preview("Morning") {
    ShowSpeechBubble { Text(.showGalleryNote) }.padding().background { ShowStage() }.preferredColorScheme(.light)
}
#Preview("Evening, largest text") {
    ShowSpeechBubble { Text(.showGalleryNote) }.padding().background { ShowStage() }
        .preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
