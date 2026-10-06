import RealityKit
import SwiftUI

/// A decorative character. The caller supplies adjacent localized status and speech, when appropriate.
struct TomiCompanion: View {
    let state: CompanionState
    var turned = false
    var reduceMotion = false
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var rig = CompanionRig()
    @State private var visible = false

    private var presentation: CompanionPresentation {
        CompanionPresentation(
            state: state,
            turned: turned,
            moving: CompanionMotionPolicy.moves(
                reduced: systemReduceMotion || reduceMotion,
                active: scenePhase == .active,
                visible: visible
            )
        )
    }

    var body: some View {
        RealityView { content in
            content.camera = .virtual
            content.add(CompanionStage.make())
            content.add(rig.root)
            rig.configure(presentation)
            rig.listen(to: content, moving: presentation.moving)
        } update: { content in
            rig.configure(presentation)
            rig.listen(to: content, moving: presentation.moving)
        }
        .accessibilityHidden(true)
        .onAppear { visible = true }
        .onDisappear {
            visible = false
            rig.stop()
        }
    }
}

#Preview {
    TomiCompanion(state: .listening)
        .frame(height: MascotSize.companion)
        .background(ColorRole.paper.color)
}
