import SwiftUI

/// A rule filled from the left by a share of its length, such as the XP towards the next level. The number
/// it draws is always written next to it, so it is hidden from VoiceOver.
struct FractionRule: View {
    /// From 0 (empty) to 1 (full). Anything outside is drawn as the nearer end.
    let fraction: Double

    var body: some View {
        Rectangle()
            .fill(ColorRole.rule.color)
            .overlay {
                Rectangle()
                    .fill(ColorRole.cobalt.color)
                    .scaleEffect(x: min(max(fraction, 0), 1), anchor: .leading)
            }
            .frame(height: RuleWeight.double)
            .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: Spacing.medium) {
        FractionRule(fraction: 0)
        FractionRule(fraction: 0.73)
        FractionRule(fraction: 1)
    }
    .padding()
    .background(ColorRole.paper.color)
}
