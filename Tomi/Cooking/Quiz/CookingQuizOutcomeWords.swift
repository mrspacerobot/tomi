import SwiftUI

/// The words under the note's title: the server's explanation when right, otherwise what the cook can do.
struct CookingQuizOutcomeWords: View {
    let outcome: CookingQuizOutcome

    var body: some View {
        switch outcome {
        case .right(let explanation):
            if let explanation {
                Text(verbatim: explanation).textStyle(.showText)
            }
        case .wrong:
            Text(.cookingQuizWrongMessage).textStyle(.showText)
        case .problem(let problem):
            Text(problem.message).textStyle(.showText)
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
