import SwiftUI
import TomiCore

/// The parts of the dish the recipe leaves out for this cook, when it leaves any out.
struct SuggestionOmittedLine: View {
    let leftOut: [LeftOutPart]
    let style: TextStyle

    var body: some View {
        if !leftOut.isEmpty {
            Text(.suggestionOmitted(leftOut.map(\.name).formatted(.list(type: .and))))
                .textStyle(style)
                .accessibilityIdentifier("suggestion-omitted")
        }
    }
}
