import SwiftUI

/// Empty room on a screen where the companion stands. The companion itself is drawn by one
/// `CompanionHost` above the screens, so it is not created and destroyed on every page.
struct CompanionSlot: View {
    let state: CompanionState
    let side: CGFloat

    var body: some View {
        Color.clear
            .frame(width: side, height: side)
            .anchorPreference(key: CompanionPlacementKey.self, value: .bounds) { bounds in
                CompanionPlacement(bounds: bounds, state: state)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    CompanionSlot(state: .idle, side: MascotSize.companionWelcome)
        .background(ColorRole.paper.color)
}
