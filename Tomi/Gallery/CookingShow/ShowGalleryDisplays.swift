#if DEBUG
    import SwiftUI

    struct ShowGalleryDisplays: View {
        var body: some View {
            VStack(spacing: ShowSize.rowGap) {
                ShowMarquee(title: .showGalleryTitle, kicker: .showGalleryOnAir)
                    .accessibilityIdentifier("show-gallery-title")
                ShowLowerThird(label: .showGalleryOnAir, title: .showGalleryEpisodeGuide)
                    .accessibilityIdentifier("show-gallery-lower-third")
                ShowSpeechBubble { Text(.showGalleryNote) }
                    .accessibilityIdentifier("show-gallery-bubble")
                ShowCard { Text(.showGalleryCard).textStyle(.cardTitle) }
                    .accessibilityIdentifier("show-gallery-card")
            }
        }
    }

    #Preview("Morning") { ShowGalleryDisplays().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowGalleryDisplays().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
