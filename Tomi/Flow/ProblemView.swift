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
        .textStyle(.showText, color: .showWhite)
        .padding(ShowSize.cardVertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorRole.showError.color, in: .rect(cornerRadius: Radius.showControl))
        .accessibilityIdentifier("problem")
    }
}

#Preview {
    ProblemView(problem: ProblemText(BackendError.unreachable))
        .padding()
        .background { ShowStage() }
}
