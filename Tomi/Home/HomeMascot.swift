import SwiftUI

/// Tomi at the top of home, as large as on the welcome, with room above him so he does not crowd the top.
struct HomeMascot: View {
    var body: some View {
        TomiMascot()
            .frame(width: MascotSize.welcome, height: MascotSize.welcome)
            .accessibilityLabel(Text(.mascotLabel))
            .padding(.top, Spacing.xxLarge)
    }
}

#Preview {
    HomeMascot()
        .background(ColorRole.paper.color)
}
