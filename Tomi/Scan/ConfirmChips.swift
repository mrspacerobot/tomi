import SwiftUI

/// The items as chips: ticked ones on, the others off. Things the server did not know are listed in words.
struct ConfirmChips: View {
    let model: ScanModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            FlowLayout {
                ForEach(model.list.items.filter { $0.ingredient != nil }) { item in
                    Chip(name: item.label, kind: kind(of: item)) {
                        model.list.toggle(item.id)
                    }
                    .accessibilityIdentifier("confirm-item-" + item.label)
                }
            }
            ForEach(model.list.items.filter { $0.ingredient == nil }) { item in
                Text(.confirmUnknown(item.label))
                    .textStyle(.description)
            }
        }
    }

    private func kind(of item: ConfirmItem) -> ChipKind {
        if item.isTicked {
            return .on
        }
        return .off
    }
}
