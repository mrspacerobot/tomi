#if DEBUG
    import SwiftUI

    struct ShowGallery: View {
        static let launchArgument = "--cooking-show-gallery"

        var showsSamples = false
        @State private var model = GalleryModel()

        var body: some View {
            ScrollViewReader { scroll in
                ScrollView { content }
                    .background { ShowStage() }
                    .onAppear {
                        if showsSamples, let section = GalleryLaunch.section {
                            scroll.scrollTo(section, anchor: .top)
                        }
                    }
            }
        }

        @ViewBuilder private var content: some View {
            if showsSamples {
                GalleryContents(model: model)
            } else {
                VStack(spacing: ShowSize.rowGap) {
                    ShowGalleryDisplays()
                    ShowGalleryControls()
                }
                .padding(.horizontal, ShowSize.edge)
                .padding(.vertical, ShowSize.footer)
            }
        }

    }

    #Preview("Morning") { ShowGallery().preferredColorScheme(.light) }
    #Preview("Evening") { ShowGallery().preferredColorScheme(.dark) }
    #Preview("Largest text") { ShowGallery().dynamicTypeSize(.accessibility5) }
#endif
