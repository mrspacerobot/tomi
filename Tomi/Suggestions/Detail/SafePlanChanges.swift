import SwiftUI
import TomiCore

/// The swaps and left-out parts of the plan, each with the server's caveat and ratio.
struct SafePlanChanges: View {
    let suggestion: Suggestion

    var body: some View {
        ForEach(suggestion.safePlan.substitutions, id: \.id) { swap in
            SafePlanSwapRow(swap: swap)
        }
        SuggestionOmittedLine(suggestion: suggestion, style: .body)
    }
}
