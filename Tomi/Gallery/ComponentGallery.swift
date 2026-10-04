#if DEBUG
    import SwiftUI

    /// Every component of the design system in every state, on one screen, to compare with the mockups and
    /// for UI tests to tap. Debug builds only, opened with the launch argument of `GalleryLaunch`.
    struct ComponentGallery: View {
        @State private var model = GalleryModel()

        var body: some View {
            ScrollViewReader { scroll in
                ScrollView {
                    GalleryContents(model: model)
                }
                .background(ColorRole.paper.color)
                .onAppear {
                    if let section = GalleryLaunch.section {
                        scroll.scrollTo(section, anchor: .top)
                    }
                }
            }
        }
    }

    #Preview("Light") {
        ComponentGallery()
    }

    #Preview("Dark, largest text") {
        ComponentGallery()
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.accessibility5)
    }
#endif
