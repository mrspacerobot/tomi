import SwiftUI
import TomiCore

/// The heading of the original recipe, the note that it is as written, and how much it makes.
struct OriginalRecipeHeader: View {
    let recipe: OriginalRecipe

    var body: some View {
        SectionHeading(words: .suggestionOriginalTitle)
        Text(.suggestionOriginalNote)
            .textStyle(.description)
        if let yields = recipe.yields {
            OriginalYieldLine(yields: yields)
        }
    }
}
