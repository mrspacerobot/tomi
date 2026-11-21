import SwiftUI

/// A one point rule across the space it is given: cobalt under a heading, the rule colour between rows.
struct Hairline: View {
    let role: ColorRole

    init(_ role: ColorRole = .stageMuted) {
        self.role = role
    }

    var body: some View {
        Rectangle()
            .fill(role.color)
            .frame(height: RuleWeight.hairline)
            .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: Spacing.medium) {
        Hairline(.stageGold)
        Hairline()
    }
    .padding()
    .background { ShowStage() }
}
