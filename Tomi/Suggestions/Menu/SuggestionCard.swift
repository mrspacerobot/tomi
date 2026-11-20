import SwiftUI
import TomiCore

/// One dish on suggestion: its name, technique and level, the server's reason, what changed in the recipe and what
/// was checked. The button opens the recipe.
struct SuggestionCard: View {
    let suggestion: Suggestion
    let options: LibraryOptions
    /// The label set into the box of tonight's special, nil for an alternative.
    let flag: LocalizedStringResource?
    let open: () -> Void
    @Environment(\.dishPhotos) private var loader
    /// Loaded by the card, which is always on screen: the photo's own view only exists once there is a photo.
    @State private var photo: CGImage?

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                SuggestionCardHeader(suggestion: suggestion, flag: flag, photo: photo)
                SuggestionSummary(suggestion: suggestion, options: options)
                Button(action: open) { Text(.suggestionOpen) }
                    .buttonStyle(ShowPrimaryButtonStyle())
                    .accessibilityIdentifier("suggestion-open-" + suggestion.recipeID.rawValue)
            }
        }
        .task(id: suggestion.photoURL) { await loadPhoto() }
    }

    private func loadPhoto() async {
        photo = nil
        guard let url = suggestion.photoURL else {
            return
        }
        photo = await loader.image(at: url)
    }
}
