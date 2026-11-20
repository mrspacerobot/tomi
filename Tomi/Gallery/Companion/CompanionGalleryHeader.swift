#if DEBUG
    import SwiftUI

    struct CompanionGalleryHeader: View {
        let close: () -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Button(.companionClose, action: close)
                    .buttonStyle(ShowSecondaryButtonStyle())
                    .accessibilityIdentifier("companion-close")
                Text(.companionTitle).textStyle(.showTitle).accessibilityIdentifier("companion-title")
                Text(.companionSubtitle).textStyle(.showLede, color: .stageMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    #Preview { CompanionGalleryHeader(close: {}) }
#endif
