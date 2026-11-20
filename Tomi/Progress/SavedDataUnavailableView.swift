import SwiftUI

/// Shown instead of everything else when saved data cannot be opened or read.
struct SavedDataUnavailableView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: ShowSize.rowGap) {
                ShowLowerThird(title: .offAirLostScript)
                OffAirPortrait()
                Text(.savedDataUnavailableTitle).textStyle(.showTitle)
                    .accessibilityIdentifier("saved-data-unavailable-title")
                ShowSpeechBubble { Text(.savedDataUnavailableMessage) }
                    .accessibilityIdentifier("saved-data-unavailable-message")
            }
            .padding(ShowSize.edge)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { ShowStage() }
    }
}

#Preview("Morning") { SavedDataUnavailableView().preferredColorScheme(.light) }
#Preview("Evening") { SavedDataUnavailableView().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
