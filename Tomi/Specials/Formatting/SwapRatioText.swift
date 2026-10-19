import SwiftUI
import TomiCore

/// How much of a stand-in to use for the original, by weight, volume or number.
struct SwapRatioText: View {
    let ratio: SwapRatio

    var body: some View {
        switch ratio.basis {
        case .weight: Text(.suggestionRatioWeight(standIn, original))
        case .volume: Text(.suggestionRatioVolume(standIn, original))
        case .count: Text(.suggestionRatioCount(standIn, original))
        case nil: Text(.suggestionRatioPlain(standIn, original))
        }
    }

    private var standIn: String {
        ratio.standIn.formatted()
    }

    private var original: String {
        ratio.original.formatted()
    }
}
