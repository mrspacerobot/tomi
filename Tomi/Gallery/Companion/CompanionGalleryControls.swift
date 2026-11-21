#if DEBUG
    import SwiftUI

    struct CompanionGalleryControls: View {
        @Binding var state: CompanionState
        @Binding var still: Bool
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize

        private var columns: [GridItem] {
            let column = GridItem(.flexible())
            if dynamicTypeSize.isAccessibilitySize { return [column] }
            return [column, column]
        }

        var body: some View {
            LazyVGrid(columns: columns, spacing: Spacing.small) {
                ForEach(CompanionState.allCases, id: \.self) { option in
                    CompanionStateButton(option: option, selected: state == option) { state = option }
                }
                Button(.companionStill) { still.toggle() }
                    .buttonStyle(ShowSecondaryButtonStyle())
                    .accessibilitySelected(still)
                    .accessibilityIdentifier("companion-still")
            }
        }
    }

    #Preview { CompanionGalleryControls(state: .constant(.idle), still: .constant(false)) }
#endif
