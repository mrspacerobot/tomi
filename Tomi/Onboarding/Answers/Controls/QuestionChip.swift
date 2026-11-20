import SwiftUI

struct QuestionChip: View {
    let name: String
    let kind: ChipKind
    let action: () -> Void
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        if showStyle && kind != .removable {
            ShowChip(selected: kind == .on, action: action, label: { Text(verbatim: name) })
        } else {
            Chip(name: name, kind: kind, action: action)
        }
    }
}

#Preview {
    QuestionChip(name: "Sample", kind: .on, action: {}).environment(\.usesShowQuestionStyle, true)
}
