import SwiftUI
import TomiCore

/// Graph-authored technique introduction before a cook prepares the adapted recipe.
struct CookingIntroductionView: View {
    let suggestion: Suggestion
    @Binding var path: [HomeRoute]
    @State private var refusal: CookingIntroductionRefusal?
    @State private var startTask: Task<Void, Never>?
    @State private var model: CookingIntroductionModel

    init(suggestion: Suggestion, flow: AppFlowModel, path: Binding<[HomeRoute]>) {
        self.suggestion = suggestion
        self._path = path
        _model = State(initialValue: CookingIntroductionModel(suggestion: suggestion, profile: flow.profile))
    }

    var body: some View {
        ScrollView { content }
            .background(ColorRole.paper.color)
            .navigationTitle(Text(.cookingIntroductionTitle))
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $refusal) { _ in
                Alert(
                    title: Text(.cookingRefreshRefusedTitle),
                    message: Text(.cookingRefreshRefusedMessage),
                    dismissButton: .default(Text(.commonOkay))
                )
            }
            .onAppear { model.activate() }
            .onDisappear {
                startTask?.cancel()
                model.cancel()
            }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: Spacing.xLarge) {
            CookingIntroductionHeader(suggestion: suggestion)
            CookingIntroductionTeaching(suggestion: suggestion)
            CookingWhyTonight(reason: suggestion.reason)
            CookingIntroductionActions(
                model: model,
                start: start,
                close: { path.removeLast() }
            )
        }
        .padding(Spacing.screenMargin)
    }

    private func start() {
        guard startTask == nil else { return }
        startTask = Task { await completeStart() }
    }

    private func completeStart() async {
        let result = await model.prepare()
        startTask = nil
        guard !Task.isCancelled, path.last == .introduction(suggestion) else { return }
        show(result)
    }

    private func show(_ result: CookingIntroductionStartResult) {
        switch result {
        case .ready: path.append(.preparation(suggestion))
        case .restrictionsChanged: refusal = .restrictionsChanged
        case .profileUnavailable: refusal = .profileUnavailable
        case .unavailable: refusal = .restrictionsChanged
        case .cancelled: return
        }
    }
}
