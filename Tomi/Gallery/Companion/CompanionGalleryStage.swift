#if DEBUG
    import SwiftUI

    struct CompanionGalleryStage: View {
        let state: CompanionState
        let still: Bool
        @Environment(\.accessibilityReduceMotion) private var systemReduced

        private var reduced: Bool {
            systemReduced || still || ProcessInfo.processInfo.arguments.contains("--companion-reduce-motion")
        }

        var body: some View {
            VStack(spacing: Spacing.small) {
                CompanionGalleryViewport(state: state, reduced: reduced)
                Text(state.line).textStyle(.body).multilineTextAlignment(.center)
                    .accessibilityIdentifier("companion-line")
                if reduced {
                    Text(.companionMotionStill).textStyle(.caption).accessibilityIdentifier("companion-motion-still")
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("companion-stage")
        }
    }

    #Preview { CompanionGalleryStage(state: .listening, still: false) }
#endif
