import SwiftUI
import TomiCore

/// How much of a stand-in to use for the original, by weight, volume or number.
struct SwapRatioText: View {
    let ratio: SwapRatio

    var body: some View {
        switch ratio.basis {
        case .weight: Text(.offerRatioWeight(standIn, original))
        case .volume: Text(.offerRatioVolume(standIn, original))
        case .count: Text(.offerRatioCount(standIn, original))
        case nil: Text(.offerRatioPlain(standIn, original))
        }
    }

    private var standIn: String {
        ratio.standIn.formatted()
    }

    private var original: String {
        ratio.original.formatted()
    }
}
