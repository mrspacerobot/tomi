import SwiftUI

extension View {
    /// Tells VoiceOver in words that a row or a chip is ticked, which the eye reads from the tick.
    func accessibilitySelected(_ isSelected: Bool) -> some View {
        var traits: AccessibilityTraits = []
        if isSelected {
            traits = .isSelected
        }
        return accessibilityAddTraits(traits)
    }
}
