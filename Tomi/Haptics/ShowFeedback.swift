import SwiftUI

/// A trigger that changes with each visible cue, including consecutive cues of the same kind.
struct ShowFeedback<Trigger: Equatable>: ViewModifier {
    let haptic: ShowHaptic
    let trigger: Trigger
    @State private var player = ShowHapticPlayer()
    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content
            .sensoryFeedback(trigger: trigger) { _, _ in haptic.feedback }
            .onChange(of: trigger) { _, _ in
                if haptic == .wrap && scenePhase == .active { player.playWrap() }
            }
    }
}
