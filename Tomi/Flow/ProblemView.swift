import SwiftUI

/// A problem in Tomi's words, or the server's when Tomi has none.
struct ProblemView: View {
    let problem: ProblemText

    var body: some View {
        Group {
            if let resource = problem.resource {
                Text(resource)
            } else {
                Text(verbatim: problem.serverMessage)
            }
        }
        .textStyle(.body)
        .foregroundStyle(ColorRole.ink.color)
        .accessibilityIdentifier("problem")
    }
}

#Preview {
    ProblemView(problem: ProblemText(BackendError.unreachable))
        .padding()
        .background(ColorRole.paper.color)
}
