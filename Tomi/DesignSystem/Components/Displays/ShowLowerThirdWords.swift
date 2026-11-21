import SwiftUI

struct ShowLowerThirdWords: View {
    let label: LocalizedStringResource?
    let title: LocalizedStringResource

    var body: some View {
        if let label {
            ShowLowerThirdSegment(words: label, ink: .showWhite, ground: .showRed)
        }
        ShowLowerThirdSegment(words: title, ink: .showInk, ground: .showGold)
    }
}

#Preview("Morning") { ShowLowerThird(label: .showGalleryOnAir, title: .showGalleryEpisodeGuide) }
#Preview("Evening, largest text") {
    ShowLowerThird(label: .showGalleryOnAir, title: .showGalleryEpisodeGuide)
        .preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
