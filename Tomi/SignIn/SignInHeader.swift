import SwiftUI

/// The mascot with the title and the line that explains why Tomi asks the cook to sign in.
struct SignInHeader: View {
    var body: some View {
        VStack(spacing: Spacing.xLarge) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityLabel(Text(.mascotLabel))
            SignInWords()
        }
    }
}

#Preview {
    SignInHeader()
        .background(ColorRole.paper.color)
}
