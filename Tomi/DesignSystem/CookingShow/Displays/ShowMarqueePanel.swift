import SwiftUI

struct ShowMarqueePanel: View {
    let title: LocalizedStringResource
    let kicker: LocalizedStringResource?

    var body: some View {
        VStack(spacing: ShowSize.compact) {
            if let kicker { Text(kicker).textStyle(.marqueeKicker) }
            Text(title).textStyle(.marquee).accessibilityAddTraits(.isHeader)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, ShowSize.marqueeHorizontal)
        .padding(.vertical, ShowSize.marqueeVertical)
        .background(ColorRole.showRed.color, in: .rect(cornerRadius: Radius.showMarqueePanel))
    }
}

#Preview("Morning") {
    ShowMarqueePanel(title: .showGalleryTitle, kicker: .showGalleryOnAir).preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowMarqueePanel(title: .showGalleryTitle, kicker: .showGalleryOnAir)
        .preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
