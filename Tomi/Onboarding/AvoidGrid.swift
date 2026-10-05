import SwiftUI
import TomiCore

/// The things the table lists to avoid, two to a row.
struct AvoidGrid: View {
    let items: [AvoidItem]
    let answer: AvoidAnswer
    let tap: (AvoidItemID) -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Two to a row, until the words are too large for half a screen and a name would break mid-word.
    private var columns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            return [GridItem(.flexible())]
        }
        return [GridItem(.flexible(), spacing: Spacing.small), GridItem(.flexible())]
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: Spacing.none) {
            ForEach(items) { item in
                AvoidCell(name: item.name.forCook, isSelected: answer.isTicked(item.id), action: { tap(item.id) })
                    .accessibilityIdentifier("onboarding-avoid-\(item.id.rawValue)")
            }
        }
    }
}
