import SwiftUI

/// The title of a scan screen and, under it, anything that went wrong.
struct ScanHeader: View {
    let title: LocalizedStringResource
    let identifier: String
    let problem: ProblemText?

    var body: some View {
        Text(title)
            .textStyle(.displayL)
            .accessibilityIdentifier(identifier)
        if let problem {
            ProblemView(problem: problem)
        }
    }
}
