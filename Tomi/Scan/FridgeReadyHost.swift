import SwiftUI

struct FridgeReadyHost: View {
    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                Image(systemName: "refrigerator")
                    .textStyle(.showStat, color: .showRed)
                    .accessibilityHidden(true)
                Text(.fridgePhotoInvitation).textStyle(.cardTitle)
                Text(.fridgePhotoExplanation).textStyle(.showText, color: .showMuted)
                TomiHostHead().frame(width: MascotSize.home, height: MascotSize.home)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview { FridgeReadyHost().background { ShowStage() } }
