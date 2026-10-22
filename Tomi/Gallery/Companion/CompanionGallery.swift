#if DEBUG
    import SwiftUI

    struct CompanionGallery: View {
        @Environment(\.dismiss) private var dismiss
        @State private var state = CompanionGalleryLaunch.state
        @State private var still = CompanionGalleryLaunch.still

        var body: some View {
            ScrollView {
                VStack(spacing: Spacing.large) {
                    CompanionGalleryHeader(close: { dismiss() })
                    CompanionGalleryStage(state: state, still: still)
                    CompanionGalleryControls(state: $state, still: $still)
                    Text(.companionDemoNote).textStyle(.caption).foregroundStyle(ColorRole.inkFaded.color)
                }
                .padding(Spacing.screenMargin)
            }
            .background(ColorRole.paper.color)
        }
    }

    #Preview { CompanionGallery() }
#endif
