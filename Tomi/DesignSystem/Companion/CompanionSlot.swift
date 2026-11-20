import SwiftUI

/// The animated companion standing in a square of `side` points on a screen.
struct CompanionSlot: View {
    /// Lets UI tests find the companion, whose drawing itself is hidden from VoiceOver.
    static let identifier = "tomi-companion"

    let state: CompanionState
    let side: CGFloat
    var appearance: CompanionAppearance = .tastingMenu

    var body: some View {
        ZStack {
            TomiCompanion(state: state, appearance: appearance)
        }
        .frame(width: side, height: side)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(Self.identifier)
    }
}

#Preview {
    CompanionSlot(state: .idle, side: MascotSize.companionWelcome)
        .background(ColorRole.paper.color)
}
