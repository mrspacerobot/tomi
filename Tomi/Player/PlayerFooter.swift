import SwiftUI

/// Stopping early, which logs a cook that counts for nothing, and the way forward.
struct PlayerFooter: View {
    let model: PlayerModel
    let done: () -> Void

    var body: some View {
        HStack(spacing: Spacing.small) {
            Button(action: stop) { Text(.playerStop) }
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("player-stop")
            PlayerForwardButton(model: model, done: done)
        }
        .padding(Spacing.stepMargin)
    }

    private func stop() {
        model.stop()
        done()
    }
}
