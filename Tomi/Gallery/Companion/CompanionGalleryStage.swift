#if DEBUG
    import SwiftUI

    struct CompanionGalleryStage: View {
        let state: CompanionState
        let turned: Bool
        @Environment(\.accessibilityReduceMotion) private var systemReduced

        private var reduced: Bool {
            systemReduced || ProcessInfo.processInfo.arguments.contains("--companion-reduce-motion")
        }

        var body: some View {
            VStack(spacing: Spacing.small) {
                TomiCompanion(state: state, turned: turned, reduceMotion: reduced)
                    .frame(height: MascotSize.companion)
                    .accessibilityIdentifier("companion-viewport")
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

    #Preview { CompanionGalleryStage(state: .listening, turned: false) }
#endif
