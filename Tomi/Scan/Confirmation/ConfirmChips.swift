import SwiftUI

/// The items as chips: ticked ones on, the others off. Things the server did not know are listed in words.
struct ConfirmChips: View {
    let model: ScanModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            FlowLayout {
                ForEach(model.list.items.filter { $0.ingredient != nil }) { item in
                    ConfirmChip(item: item, action: { model.list.toggle(item.id) })
                        .accessibilityIdentifier("confirm-item-" + item.label)
                }
            }
            UnknownItems(items: model.list.items.filter { $0.ingredient == nil })
        }
    }
}
