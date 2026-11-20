import SwiftUI

struct ShowChip<Label: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let selected: Bool
    let action: () -> Void
    @ViewBuilder let label: Label

    var body: some View {
        Button(action: action) {
            ShowChipFace(selected: selected) { label }
        }
        .buttonStyle(.plain)
        .accessibilitySelected(selected)
        .animation(selectionAnimation, value: selected)
        .showFeedback(.selection, trigger: selected)
    }

    private var selectionAnimation: Animation? {
        if reduceMotion { return nil }
        return .snappy(duration: 0.22)
    }
}

#Preview("Morning") {
    ShowChip(selected: false, action: {}, label: { Text(.galleryTitle) })
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowChip(selected: true, action: {}, label: { Text(.galleryTitle) })
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
