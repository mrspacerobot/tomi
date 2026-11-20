import SwiftUI

struct ShowLowerThird: View {
    var label: LocalizedStringResource?
    let title: LocalizedStringResource

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 0) { ShowLowerThirdWords(label: label, title: title) }.fixedSize()
            VStack(spacing: 0) { ShowLowerThirdWords(label: label, title: title) }
        }
        .clipShape(.rect(cornerRadius: Radius.showSmall))
        .shadow(color: ColorRole.showScrim.color, radius: ShowShadow.lowerThirdRadius, y: ShowShadow.lowerThirdOffset)
        .accessibilityElement(children: .combine)
    }
}

#Preview("Morning") {
    ShowLowerThird(label: .showGalleryOnAir, title: .showGalleryEpisodeGuide)
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowLowerThird(label: .showGalleryOnAir, title: .showGalleryEpisodeGuide)
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
