import SwiftUI

/// Shown while Tomi checks sign-in and fetches the cook's answers.
struct StartingView: View {
    static let captureArgument = "--capture-opening-lights-up"
    var body: some View {
        VStack(spacing: ShowSize.rowGap) {
            SignInWords()
            ProgressView().tint(ColorRole.showGold.color).accessibilityHidden(true)
            Text(.openingWarmingLights).textStyle(.showLede, color: .showWhite)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { ShowCurtainFabric().ignoresSafeArea() }
        .accessibilityIdentifier("opening-lights-up")
    }
}

#Preview("Morning") { StartingView().preferredColorScheme(.light) }
#Preview("Evening") { StartingView().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
