#if DEBUG
    import SwiftUI

    struct CompanionGalleryControls: View {
        @Binding var state: CompanionState
        @Binding var turned: Bool
        private let columns = [GridItem(.flexible()), GridItem(.flexible())]

        var body: some View {
            LazyVGrid(columns: columns, spacing: Spacing.small) {
                ForEach(CompanionState.allCases, id: \.self) { option in
                    CompanionStateButton(option: option, selected: state == option) { state = option }
                }
                Button(.companionTurn) { turned.toggle() }
                    .buttonStyle(.tomiSecondary)
                    .accessibilitySelected(turned)
                    .accessibilityIdentifier("companion-turn")
            }
        }
    }

    #Preview { CompanionGalleryControls(state: .constant(.idle), turned: .constant(false)) }
#endif
