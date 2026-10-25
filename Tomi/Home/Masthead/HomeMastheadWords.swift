import SwiftUI
import TomiCore

struct HomeMastheadWords: View {
    let date: Date

    var body: some View {
        VStack(spacing: Spacing.xxSmall) {
            TomiMascot()
                .frame(width: MascotSize.home, height: MascotSize.home)
                .accessibilityHidden(true)
            Text(.homeMastheadTitle).textStyle(.displayM).accessibilityIdentifier("home-title")
            Text(date, format: .dateTime.weekday(.wide).month(.wide).day())
                .textStyle(.caption)
                .foregroundStyle(ColorRole.inkFaded.color)
                .accessibilityIdentifier("home-date")
        }
    }
}

#Preview {
    HomeMasthead(path: .constant([]), date: .now)
        .padding()
        .background(ColorRole.paper.color)
}
