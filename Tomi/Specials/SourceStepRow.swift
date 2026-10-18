import SwiftUI
import TomiCore

/// One step of the graph's recipe: its number, its text as written and how long it takes.
struct SourceStepRow: View {
    let number: Int
    let step: SourceStep

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(.playerStep(number))
                .textStyle(.label)
                .textCase(.uppercase)
            Text(verbatim: step.text)
                .textStyle(.step)
            if let time = step.time, let words = SourceTimeFormat.text(for: time) {
                Text(verbatim: words)
                    .textStyle(.description)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.xSmall)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("offer-source-step-\(number)")
    }
}
