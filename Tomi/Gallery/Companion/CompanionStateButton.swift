#if DEBUG
    import SwiftUI

    struct CompanionStateButton: View {
        let option: CompanionState
        let selected: Bool
        let action: () -> Void

        private var kind: TomiButtonKind {
            if selected { return .primary }
            return .secondary
        }

        var body: some View {
            Button(option.label, action: action)
                .buttonStyle(TomiButtonStyle(kind: kind))
                .accessibilitySelected(selected)
                .accessibilityIdentifier("companion-state-\(option.rawValue)")
        }
    }

    #Preview { CompanionStateButton(option: .thinking, selected: true, action: {}) }
#endif
