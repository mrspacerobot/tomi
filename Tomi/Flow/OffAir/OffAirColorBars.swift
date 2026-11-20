import SwiftUI

struct OffAirColorBars: View {
    private static let colors: [ColorRole] = [
        .showWhite, .showGold, .signalCyan, .showCorrect, .signalPink, .showAccent, .showBlue,
    ]

    var body: some View {
        HStack(spacing: Spacing.none) {
            ForEach(Self.colors, id: \.self) { role in role.color }
        }
        .frame(height: ShowSize.rowGap)
        .accessibilityHidden(true)
    }
}

#Preview { OffAirColorBars() }
