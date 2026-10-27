import SwiftUI
import TomiCore

/// Starts the guided steps, after the latest profile has been read again and the suggestion has been rechecked
/// against it: the cook's answers may have changed since the introduction.
struct CookingBeginStepsButton: View {
    let suggestion: Suggestion
    @Binding var path: [HomeRoute]
    @State private var model: CookingIntroductionModel
    @State private var refusal: CookingIntroductionRefusal?
    @State private var startTask: Task<Void, Never>?

    init(suggestion: Suggestion, flow: AppFlowModel, path: Binding<[HomeRoute]>) {
        self.suggestion = suggestion
        self._path = path
        _model = State(initialValue: CookingIntroductionModel(suggestion: suggestion, profile: flow.profile))
    }

    var body: some View {
        Button(action: begin) {
            Text(label).frame(maxWidth: .infinity)
        }
        .buttonStyle(.tomiPrimary)
        .disabled(model.isRefreshingProfile)
        .accessibilityIdentifier("cooking-steps-begin")
        .cookingStartAlert($refusal, path: $path)
        .onAppear { model.activate() }
        .onDisappear {
            startTask?.cancel()
            model.cancel()
        }
    }

    private var label: LocalizedStringResource {
        if model.isRefreshingProfile {
            return .cookingCheckingProfile
        }
        return .cookingStepsBegin
    }

    private func begin() {
        guard startTask == nil else { return }
        startTask = Task { await completeBegin() }
    }

    private func completeBegin() async {
        let result = await model.prepare()
        startTask = nil
        guard !Task.isCancelled, path.last == .preparation(suggestion) else { return }
        if result == .ready {
            path.append(.steps(CookingSession(suggestion: suggestion)))
            return
        }
        refusal = result.refusal
    }
}
