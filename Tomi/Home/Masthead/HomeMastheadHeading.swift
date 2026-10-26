import SwiftUI
import TomiCore

/// The masthead's title and the date, centred even when large text wraps them onto several lines.
struct HomeMastheadHeading: View {
    let date: Date

    var body: some View {
        VStack(spacing: Spacing.xxSmall) {
            Text(.homeMastheadTitle)
                .textStyle(.displayM)
                .accessibilityIdentifier("home-title")
            Text(date, format: .dateTime.weekday(.wide).month(.wide).day())
                .textStyle(.caption)
                .foregroundStyle(ColorRole.inkFaded.color)
                .accessibilityIdentifier("home-date")
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    HomeMastheadHeading(date: .now)
        .padding()
        .background(ColorRole.paper.color)
}
