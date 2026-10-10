import SwiftUI

/// Tomi at the top of home.
struct HomeMascot: View {
    var body: some View {
        TomiMascot()
            .frame(width: MascotSize.welcome, height: MascotSize.welcome)
            .accessibilityLabel(Text(.mascotLabel))
    }
}
