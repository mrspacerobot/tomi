import SwiftUI

struct ShowTabButton<Tab: Hashable>: View {
    let item: ShowTabItem<Tab>
    @Binding var selection: Tab

    var body: some View {
        Button {
            selection = item.id
        } label: {
            ShowTabGlyph(icon: item.icon)
                .foregroundStyle(ink.color)
                .frame(width: ShowSize.tabHighlightWidth, height: ShowSize.tabHighlightHeight)
                .background(fill, in: .rect(cornerRadius: Radius.showIcon))
                .frame(minWidth: TouchTarget.minimum, maxWidth: .infinity)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(item.title))
        .accessibilityIdentifier(item.accessibilityID)
        .accessibilitySelected(isSelected)
    }

    private var isSelected: Bool { item.id == selection }

    private var ink: ColorRole {
        if isSelected { return .showRed }
        return .showMuted
    }

    private var fill: Color {
        if isSelected { return ColorRole.showTabHighlight.color }
        return .clear
    }
}

#if DEBUG
    #Preview("Morning") { ShowGalleryTabs().preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowGalleryTabs().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
