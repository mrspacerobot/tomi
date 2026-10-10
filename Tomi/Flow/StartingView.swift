import SwiftUI

/// Shown while Tomi checks the sign-in and fetches the cook's answers.
struct StartingView: View {
    var body: some View {
        VStack(spacing: Spacing.medium) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityHidden(true)
            ProgressView()
                .accessibilityLabel(Text(.startingLabel))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    StartingView()
}
