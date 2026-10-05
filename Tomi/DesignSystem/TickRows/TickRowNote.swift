import SwiftUI

/// The note stays readable on the wash band of a selected row.
struct TickRowNote: View {
    let words: String
    let isSelected: Bool

    var body: some View {
        Text(words)
            .textStyle(.description, color: color)
            .layoutPriority(1)
    }

    private var color: ColorRole {
        if isSelected {
            return .ink
        }
        return .inkFaded
    }
}

#Preview {
    TickRowNote(words: String(localized: .sampleTickOvenNote), isSelected: true)
        .background(ColorRole.wash.color)
}
