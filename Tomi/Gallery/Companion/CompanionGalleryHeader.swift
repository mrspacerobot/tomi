#if DEBUG
    import SwiftUI

    struct CompanionGalleryHeader: View {
        let close: () -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Button(.companionClose, action: close).buttonStyle(.tomiSecondary)
                Text(.companionTitle).textStyle(.displayL).accessibilityIdentifier("companion-title")
                Text(.companionSubtitle).textStyle(.body).foregroundStyle(ColorRole.inkFaded.color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    #Preview { CompanionGalleryHeader(close: {}) }
#endif
