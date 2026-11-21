import SwiftUI

struct QuestionChip: View {
    let name: String
    let kind: ChipKind
    let action: () -> Void

    var body: some View {
        if kind == .removable {
            removeButton
        } else {
            ShowChip(selected: kind == .on, action: action, label: { Text(verbatim: name) })
        }
    }

    private var removeButton: some View {
        Button(action: action) {
            ShowChipFace(selected: false) {
                Text(verbatim: name)
                Icon(.close, size: .small)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(.chipRemoveLabel(name)))
    }
}

#Preview {
    QuestionChip(name: "Sample", kind: .on, action: {})
}
