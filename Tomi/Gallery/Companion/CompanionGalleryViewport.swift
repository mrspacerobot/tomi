#if DEBUG
    import SwiftUI

    /// The companion large enough to judge the drawing, findable by UI tests that compare its still poses.
    struct CompanionGalleryViewport: View {
        let state: CompanionState
        let reduced: Bool

        var body: some View {
            ZStack {
                TomiCompanion(state: state, reduceMotion: reduced)
            }
            .frame(width: MascotSize.companion, height: MascotSize.companion)
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("companion-viewport")
        }
    }

    #Preview { CompanionGalleryViewport(state: .celebrating, reduced: true) }
#endif
