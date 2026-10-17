import SwiftUI

/// Where a screen wants the companion and what it is doing there.
struct CompanionPlacement {
    let bounds: Anchor<CGRect>
    let state: CompanionState
}

/// Carries the placement from a screen's `CompanionSlot` up to the `CompanionHost` that draws the companion.
struct CompanionPlacementKey: PreferenceKey {
    static var defaultValue: CompanionPlacement? { nil }

    static func reduce(value: inout CompanionPlacement?, nextValue: () -> CompanionPlacement?) {
        if let next = nextValue() {
            value = next
        }
    }
}
