import SwiftUI
import TomiCore

/// The ratio and the caveat the server gives with a swap, when it gives them.
struct SwapNotes: View {
    let swap: SuggestionSwap

    var body: some View {
        if let ratio = swap.ratio {
            SwapRatioText(ratio: ratio)
                .textStyle(.description)
        }
        if let caveat = swap.caveat {
            Text(verbatim: caveat)
                .textStyle(.description)
        }
    }
}
