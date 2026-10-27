import SwiftUI

/// The note stays readable on the wash band of a selected row. On a crossed-out row it is a red label
/// (`.q-opt small` in the design kit).
struct TickRowNote: View {
    let words: String
    let isSelected: Bool
    var isCrossedOut = false

    var body: some View {
        Text(words)
            .textStyle(style, color: color)
            .layoutPriority(1)
    }

    private var style: TextStyle {
        if isCrossedOut {
            return .label
        }
        return .description
    }

    private var color: ColorRole {
        if isCrossedOut {
            return .stampRed
        }
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
