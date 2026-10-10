import SwiftUI

/// Next, or finish once the question is answered; and stopping early, which logs a cook that counts for nothing.
struct PlayerFooter: View {
    let model: PlayerModel
    let done: () -> Void

    var body: some View {
        HStack(spacing: Spacing.small) {
            Button(action: stop) { Text(.playerStop) }
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("player-stop")
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
        .padding(Spacing.stepMargin)
    }

    private func finish() {
        model.finish()
        done()
    }

    private func stop() {
        model.stop()
        done()
    }
}
