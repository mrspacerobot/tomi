#if DEBUG
    import SwiftUI

    struct ShowGalleryControls: View {
        @State private var metric = false

        var body: some View {
            VStack(spacing: ShowSize.gap) {
                ShowBackButton { metric = false }.accessibilityIdentifier("show-gallery-back")
                ShowChip(selected: metric, action: { metric.toggle() }, label: { Text(.showGalleryChip) })
                    .accessibilityIdentifier("show-gallery-chip")
                Button(.onboardingContinue) { metric = true }
                    .buttonStyle(ShowPrimaryButtonStyle())
                    .accessibilityIdentifier("show-gallery-primary")
                ShowGalleryTabs()
            }
        }
    }

    #Preview("Morning") { ShowGalleryControls().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowGalleryControls().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
