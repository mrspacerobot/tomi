import SwiftUI

/// Home: the cook's progress and the way to tonight's dish.
struct HomeView: View {
    let flow: AppFlowModel
    let progress: SavedProgressModel
    @State private var path: [HomeRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeContent(flow: flow, progress: progress, path: $path)
                .navigationDestination(for: HomeRoute.self) { route in
                    HomeDestination(route: route, flow: flow, path: $path)
                }
        }
        .onAppear {
            progress.refresh(at: .now)
        }
    }
}

#Preview {
    HomeView(flow: .preview(), progress: .previewWithProgress())
}
