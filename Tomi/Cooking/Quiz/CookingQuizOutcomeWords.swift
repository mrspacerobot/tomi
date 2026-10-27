import SwiftUI

/// The words under the note's title: the server's explanation when right, otherwise what the cook can do.
struct CookingQuizOutcomeWords: View {
    let outcome: CookingQuizOutcome

    var body: some View {
        switch outcome {
        case .right(let explanation):
            if let explanation {
                Text(verbatim: explanation).textStyle(.body)
            }
        case .wrong:
            Text(.cookingQuizWrongMessage).textStyle(.body)
        case .problem(let problem):
            Text(problem.message).textStyle(.body)
        }
    }
}

#Preview {
    VStack {
        CookingQuizOutcomeWords(outcome: .wrong)
        CookingQuizOutcomeWords(outcome: .problem(.offline))
    }
    .padding()
}
