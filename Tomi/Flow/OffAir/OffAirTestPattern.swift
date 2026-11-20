import SwiftUI

/// A test card for the server failure screen. The words carry its status.
struct OffAirTestPattern: View {
    var body: some View {
        ShowCard {
            VStack(spacing: Spacing.none) {
                OffAirColorBars()
                OffAirStandByReadout()
            }
            .clipShape(.rect(cornerRadius: Radius.showControl))
        }
    }
}

#Preview("Morning") { OffAirTestPattern().padding().background { ShowStage() }.preferredColorScheme(.light) }
#Preview("Evening") {
    OffAirTestPattern().padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(
        .accessibility5
    )
}
