import SwiftUI

/// A server-selected dish photo at the top of a menu card. Decorative: the card's title names the dish.
struct SuggestionPhoto: View {
    let photo: CGImage

    var body: some View {
        Image(decorative: photo, scale: 1)
            .resizable()
            .scaledToFill()
            .frame(height: 156)
            .frame(maxWidth: .infinity)
            .clipped()
    }
}
