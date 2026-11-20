import SwiftUI

struct OffAirStandByReadout: View {
    var body: some View {
        Text(.offAirStandBy)
            .textStyle(.marquee)
            .multilineTextAlignment(.center)
            .padding(ShowSize.cardHorizontal)
            .frame(maxWidth: .infinity)
            .background(ColorRole.showSign.color)
            .accessibilityIdentifier("off-air-stand-by")
    }
}

#Preview { OffAirStandByReadout() }
