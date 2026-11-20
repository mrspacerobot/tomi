import SwiftUI

/// The first decision of every launch: with saved data that can be read and a server to talk to, the app;
/// without them, only the notice. Every screen that keeps the cook log belongs under the app.
struct RootView: View {
    let progress: ProgressModel
    let flow: AppFlowModel?

    var body: some View {
        if progress.shown == nil {
            SavedDataUnavailableView()
        } else if let flow {
            AppFlowView(flow: flow, progress: progress)
                .environment(\.dishPhotos, flow.services.dishPhotos)
        } else {
            NotConfiguredView()
        }
    }
}

#Preview("Saved progress") {
    RootView(progress: .previewWithProgress(), flow: .preview())
}

#Preview("Saved data unavailable") {
    RootView(progress: .previewUnavailable(), flow: .preview())
}
