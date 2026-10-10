import SwiftUI

/// The server offered a lesson this phone does not have yet, at that revision.
struct LessonMissingView: View {
    let done: () -> Void

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text(.playerMissingTitle)
                .textStyle(.title)
                .accessibilityIdentifier("player-missing")
            Text(.playerMissingMessage)
                .textStyle(.body)
            Button(action: done) { Text(.nothingTonightHome) }
                .buttonStyle(.tomiPrimary)
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.screenMargin)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    LessonMissingView(done: {})
}
