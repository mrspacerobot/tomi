#if DEBUG
    import SwiftUI

    struct CompanionStateButton: View {
        let option: CompanionState
        let selected: Bool
        let action: () -> Void

        var body: some View {
            ShowChip(selected: selected, action: action) {
                Text(option.label).frame(maxWidth: .infinity)
            }
            .accessibilityIdentifier("companion-state-\(option.rawValue)")
        }
    }

    #Preview { CompanionStateButton(option: .thinking, selected: true, action: {}) }
#endif
