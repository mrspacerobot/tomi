import SwiftUI

/// Tomi waving hello on a tinted disc, at the top of the welcome, as in the mockup (`round2.html`, `ob-welcome`).
struct OnboardingWelcomeTomi: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(ColorRole.wash.color)
                .frame(width: MascotSize.welcomeDisc, height: MascotSize.welcomeDisc)
                .accessibilityHidden(true)
            CompanionSlot(state: .idle, side: MascotSize.companionWelcome)
        }
    }
}

#Preview {
    OnboardingWelcomeTomi()
        .background(ColorRole.paper.color)
}
