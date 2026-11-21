import SwiftUI

/// Home: the cook's progress and the way to tonight's dish.
struct HomeView: View {
    let flow: AppFlowModel
    let progress: ProgressModel
    let now: () -> Date
    @Environment(\.scenePhase) private var scenePhase
    @State private var moment: Date
    @State private var path: [HomeRoute] = []

    init(flow: AppFlowModel, progress: ProgressModel, now: @escaping () -> Date = { .now }) {
        self.flow = flow
        self.progress = progress
        self.now = now
        _moment = State(initialValue: now())
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeContent(flow: flow, progress: progress, path: $path, now: moment)
                .task { await refresh() }
                .navigationDestination(for: HomeRoute.self) { route in
                    HomeDestination(route: route, flow: flow, progress: progress, path: $path)
                }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await refresh() } }
        }
        .onChange(of: flow.uploader.finishedTries) {
            progress.reload()
        }
    }

    /// Each time home shows again, such as back from the cook's answers, the server is asked for its progress.
    private func refresh() async {
        moment = now()
        await progress.refresh()
    }
}

#Preview {
    HomeView(flow: .preview(), progress: .previewWithProgress())
}
