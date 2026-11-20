#if DEBUG
    import SwiftUI

    struct ShowGallery: View {
        static let launchArgument = "--cooking-show-gallery"

        var body: some View {
            ScrollView {
                VStack(spacing: ShowSize.rowGap) {
                    ShowGalleryDisplays()
                    ShowGalleryControls()
                }
                .padding(.horizontal, ShowSize.edge)
                .padding(.vertical, ShowSize.footer)
            }
            .background { ShowStage() }
        }
    }

    #Preview("Morning") { ShowGallery().preferredColorScheme(.light) }
    #Preview("Evening") { ShowGallery().preferredColorScheme(.dark) }
    #Preview("Largest text") { ShowGallery().dynamicTypeSize(.accessibility5) }
#endif
