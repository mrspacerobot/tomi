import SwiftUI
import TomiCore

/// The heading of the original recipe, the note that it is as written, and how much it makes.
struct SourceRecipeHeader: View {
    let recipe: SourceRecipe

    var body: some View {
        SectionHeading(words: .offerSourceTitle)
        Text(.offerSourceNote)
            .textStyle(.description)
        if let yields = recipe.yields {
            SourceYieldLine(yields: yields)
        }
    }
}
