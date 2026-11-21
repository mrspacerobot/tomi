#if DEBUG
    import SwiftUI

    /// The progress rule, and a button that moves it one step on.
    struct GalleryProgress: View {
        let model: GalleryModel

        var body: some View {
            VStack(spacing: Spacing.medium) {
                ProgressRule(completed: model.completedSteps, total: GalleryModel.totalSteps)
                    .accessibilityIdentifier("gallery-progress")
                Button(action: model.nextStep) {
                    Text(.sampleButtonNext)
                }
                .buttonStyle(ShowSecondaryButtonStyle())
                .accessibilityIdentifier("gallery-progress-next")
            }
        }
    }

    #Preview {
        GalleryProgress(model: GalleryModel())
            .padding()
            .background { ShowStage() }
    }
#endif
