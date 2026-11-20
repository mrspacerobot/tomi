import SwiftUI
import TomiCore

struct ConfirmChip: View {
    let item: ConfirmItem
    let action: () -> Void

    var body: some View {
        ShowChip(selected: item.isTicked, action: action, label: { Text(verbatim: item.label) })
    }
}

#Preview {
    ConfirmChip(item: ConfirmItem(typed: NamedOption(id: "fake", name: "Eggs")), action: {})
}
