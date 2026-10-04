import SwiftUI

/// Shown instead of everything else when saved data cannot be opened or read.
/// Tomi then does not know the cook's diet or what they avoid, so no dish may be shown.
struct SavedDataUnavailableView: View {
    var body: some View {
        VStack(spacing: Spacing.small) {
            Text(.savedDataUnavailableTitle)
                .textStyle(.title)
                .accessibilityIdentifier("saved-data-unavailable-title")
            Text(.savedDataUnavailableMessage)
                .textStyle(.description)
                .accessibilityIdentifier("saved-data-unavailable-message")
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    SavedDataUnavailableView()
}
