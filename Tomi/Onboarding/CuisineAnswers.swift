import SwiftUI
import TomiCore

/// For each cuisine of the server's list: love it, happy to try it, or never.
struct CuisineAnswers: View {
    let draft: AnswersDraft

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            ForEach(draft.options.cuisines) { cuisine in
                CuisineRow(cuisine: cuisine, draft: draft)
            }
        }
    }
}

#Preview {
    CuisineAnswers(draft: .preview())
        .padding()
        .background(ColorRole.paper.color)
}
