import SwiftUI

/// The words of a tick row: the name, and after a dotted leader the note. At the accessibility text sizes
/// there is no room for both on one line, so the note goes under the name and the leader is left out.
struct TickRowWords: View {
    let name: String
    let note: String?
    let isSelected: Bool
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        layout {
            Text(name)
                .textStyle(.option)
                .layoutPriority(1)
            if let note {
                if !dynamicTypeSize.isAccessibilitySize {
                    DottedLeader()
                }
                TickRowNote(words: note, isSelected: isSelected)
            }
        }
    }

    private var layout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: Spacing.xxSmall))
        }
        return AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: Spacing.xSmall))
    }

}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.medium) {
        ForEach(Array(TickRowSample.equipment.enumerated()), id: \.offset) { index, sample in
            TickRowWords(name: sample.name, note: sample.note, isSelected: index == 0)
        }
    }
    .padding()
    .background(ColorRole.paper.color)
}
