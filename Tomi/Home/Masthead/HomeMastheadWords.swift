import SwiftUI
import TomiCore

struct HomeMastheadWords: View {
    let date: Date

    var body: some View {
        VStack(spacing: Spacing.xxSmall) {
            TomiMascot()
                .frame(width: MascotSize.home, height: MascotSize.home)
                .accessibilityHidden(true)
            HomeMastheadHeading(date: date)
        }
    }
}

#Preview {
    HomeMasthead(path: .constant([]), date: .now)
        .padding()
        .background(ColorRole.paper.color)
}
