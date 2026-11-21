import SwiftUI

/// The animated Tomi, a flat broadcast cartoon. Decorative: the caller supplies any words he says.
/// Motion follows the timeline's frames while the view is visible, its scene active and Reduce Motion off;
/// otherwise the state's complete still pose is shown. Nothing here opens a camera or microphone.
struct TomiCompanion: View {
    let state: CompanionState
    var reduceMotion = false
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var clock = CompanionClock()
    @State private var visible = false

    private var moving: Bool {
        CompanionMotionPolicy.moves(
            reduced: systemReduceMotion || reduceMotion,
            active: scenePhase == .active,
            visible: visible
        )
    }

    var body: some View {
        TimelineView(.animation(paused: !moving)) { timeline in
            let pose = clock.pose(state: state, at: timeline.date, moving: moving)
            CompanionFigure(pose: pose)
        }
        .accessibilityHidden(true)
        .onAppear { visible = true }
        .onDisappear { visible = false }
    }
}

#Preview {
    TomiCompanion(state: .idle)
        .frame(height: MascotSize.companion)
        .background { ShowStage() }
}
