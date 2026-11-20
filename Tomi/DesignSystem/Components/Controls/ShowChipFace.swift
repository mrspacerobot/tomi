import SwiftUI

struct ShowChipFace<Label: View>: View {
    let selected: Bool
    @ViewBuilder let label: Label

    var body: some View {
        HStack(spacing: ShowSize.compact) {
            if selected {
                Icon(.check, size: .small)
            }
            label
        }
        .textStyle(.showText, color: ink)
        .padding(.horizontal, ShowSize.chipHorizontal)
        .padding(.vertical, ShowSize.chipVertical)
        .background(fill.color, in: .capsule)
        .frame(minWidth: TouchTarget.minimum, minHeight: TouchTarget.minimum)
        .contentShape(.rect)
    }

    private var ink: ColorRole {
        if selected { return .showWhite }
        return .showInk
    }

    private var fill: ColorRole {
        if selected { return .showRed }
        return .showChipFill
    }
}

#Preview("Morning") {
    ShowChipFace(selected: false) { Text(.galleryTitle) }
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowChipFace(selected: true) { Text(.galleryTitle) }
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
