import SwiftUI

/// A row a cook ticks to answer a question, for one answer or for several. The row only shows whether it
/// is ticked and reports the tap: which rows are ticked is decided by a `Selection` outside the view.
/// VoiceOver reads the name and the note, and says "selected" for a ticked row.
struct TickRow: View {
    let name: String
    var note: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            TickRowFace(name: name, note: note, isSelected: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilitySelected(isSelected)
    }
}

#Preview("Light") {
    VStack(spacing: 0) {
        ForEach(Array(TickRowSample.equipment.enumerated()), id: \.offset) { index, sample in
            TickRow(name: sample.name, note: sample.note, isSelected: index == 0, action: {})
        }
    }
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text") {
    VStack(spacing: 0) {
        ForEach(Array(TickRowSample.diets.enumerated()), id: \.offset) { index, sample in
            TickRow(name: sample.name, note: sample.note, isSelected: index == 1, action: {})
        }
    }
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
