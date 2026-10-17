import SwiftUI

/// Next, or finish once the question is answered.
struct PlayerForwardButton: View {
    let model: PlayerModel
    let done: () -> Void

    var body: some View {
        if model.page == .quiz {
            Button(action: finish) { Text(.playerFinish) }
                .buttonStyle(.tomiPrimary)
                .disabled(model.chosenAnswer == nil)
                .accessibilityIdentifier("player-finish")
        } else {
            Button(action: model.next) { Text(.playerNext) }
                .buttonStyle(.tomiPrimary)
                .accessibilityIdentifier("player-next")
        }
    }

    private func finish() {
        model.finish()
        done()
    }
}
