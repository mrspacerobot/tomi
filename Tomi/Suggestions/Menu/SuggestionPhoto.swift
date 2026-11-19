import SwiftUI

/// A server-selected dish image. The card's usual content fills in while a photo is unavailable.
struct SuggestionPhoto: View {
    let url: URL?

    var body: some View {
        if let url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 156)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .accessibilityHidden(true)
                }
            }
        }
    }
}
