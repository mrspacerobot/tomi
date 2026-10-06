#if DEBUG
    import SwiftUI

    struct GalleryCompanionLink: View {
        @State private var showingCompanion = CompanionGalleryLaunch.requested

        var body: some View {
            Button(.companionOpen) { showingCompanion = true }
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("gallery-companion")
                .padding(.horizontal, Spacing.screenMargin)
                .fullScreenCover(isPresented: $showingCompanion) { CompanionGallery() }
        }
    }

    #Preview { GalleryCompanionLink() }
#endif
