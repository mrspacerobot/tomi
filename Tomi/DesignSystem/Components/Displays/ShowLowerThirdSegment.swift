import SwiftUI

struct ShowLowerThirdSegment: View {
    let words: LocalizedStringResource
    let ink: ColorRole
    let ground: ColorRole

    var body: some View {
        Text(words)
            .textStyle(.lowerThird, color: ink)
            .multilineTextAlignment(.center)
            .padding(.horizontal, ShowSize.lowerThirdHorizontal)
            .padding(.vertical, ShowSize.lowerThirdVertical)
            .frame(maxWidth: .infinity)
            .background(ground.color)
    }
}

#Preview("Morning") { ShowLowerThird(title: .showGalleryEpisodeGuide).preferredColorScheme(.light) }
#Preview("Evening, largest text") {
    ShowLowerThird(title: .showGalleryEpisodeGuide).preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
