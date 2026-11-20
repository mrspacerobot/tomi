#if DEBUG
    import SwiftUI

    struct ShowHostGallery: View {
        static let launchArgument = "--show-host-gallery"

        var body: some View {
            ScrollView {
                VStack(spacing: ShowSize.rowGap) {
                    Text(.companionTitle).textStyle(.showTitle)
                    ShowHostGalleryTiles()
                    ShowGalleryTabs()
                }
                .padding(ShowSize.edge)
            }
            .background { ShowStage() }
        }
    }

    #Preview("Morning") { ShowHostGallery().preferredColorScheme(.light) }
    #Preview("Evening") { ShowHostGallery().preferredColorScheme(.dark) }
    #Preview("Largest text") { ShowHostGallery().dynamicTypeSize(.accessibility5) }
#endif
