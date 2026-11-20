import SwiftUI

struct ShowMarquee: View {
    let title: LocalizedStringResource
    var kicker: LocalizedStringResource?

    var body: some View {
        ShowMarqueePanel(title: title, kicker: kicker)
            .padding(ShowSize.marqueeBorder)
            .background { ShowMarqueeBulbs() }
            .background(ColorRole.showSign.color, in: .rect(cornerRadius: Radius.showMarquee))
            .clipShape(.rect(cornerRadius: Radius.showMarquee))
            .shadow(color: ColorRole.showGold.color.opacity(0.4), radius: ShowShadow.marqueeGlow)
            .shadow(color: ColorRole.showScrim.color, radius: 0, y: ShowShadow.marqueeLip)
    }
}

#Preview("Morning") {
    ShowMarquee(title: .showGalleryTitle, kicker: .showGalleryOnAir)
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowMarquee(title: .showGalleryTitle, kicker: .showGalleryOnAir)
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
