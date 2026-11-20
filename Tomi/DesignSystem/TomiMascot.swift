import SwiftUI

/// Tomi printed on a page: the cartoon companion holding one still pose, scaled to fit. It never moves, so it
/// sits quietly beside reading and loading. Callers label it for VoiceOver or hide it.
struct TomiMascot: View {
    var mood: CompanionState = .idle
    var appearance: CompanionAppearance = .tastingMenu

    var body: some View {
        CompanionFigure(pose: mood.stillPose, appearance: appearance)
            .accessibilityElement()
    }
}

#Preview {
    TomiMascot(mood: .thinking)
        .frame(width: MascotSize.welcome, height: MascotSize.welcome)
        .padding()
        .background(ColorRole.paper.color)
}
