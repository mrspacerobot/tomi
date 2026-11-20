import SwiftUI
import TomiCore

/// What differs from the graph's own recipe for this cook: each swap with its caveat, and each part left out.
struct ChangesSection: View {
    let changes: RecipeChanges

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            SectionHeading(words: .suggestionChangesTitle, showCardStyle: true)
            ChangeRows(changes: changes)
        }
    }
}
