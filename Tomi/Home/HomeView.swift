import SwiftUI

/// Home: the cook's progress and the way to tonight's dish.
struct HomeView: View {
    let flow: AppFlowModel
    let progress: SavedProgressModel
    let now: () -> Date
    @Environment(\.scenePhase) private var scenePhase
    @State private var moment: Date
    @State private var path: [HomeRoute] = []

    init(flow: AppFlowModel, progress: SavedProgressModel, now: @escaping () -> Date = { .now }) {
        self.flow = flow
        self.progress = progress
        self.now = now
        _moment = State(initialValue: now())
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeContent(flow: flow, progress: progress, path: $path, now: moment)
                .navigationDestination(for: HomeRoute.self) { route in
                    HomeDestination(route: route, flow: flow, path: $path)
                }
        }
        .onAppear(perform: refresh)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { refresh() }
        }
    }

    private func refresh() {
        moment = now()
        progress.refresh(at: moment)
    }
}

#Preview {
    HomeView(flow: .preview(), progress: .previewWithProgress())
}
