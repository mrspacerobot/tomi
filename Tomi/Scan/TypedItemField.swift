import SwiftUI

/// A field to type what the photo missed. An ambiguous word shows the server's candidates to pick from.
struct TypedItemField: View {
    @Bindable var typing: TypedItemModel
    let model: ScanModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HStack(spacing: Spacing.small) {
                TextField(text: $typing.text) { Text(.confirmTypePrompt) }
                    .textStyle(.body)
                    .onSubmit(add)
                    .accessibilityIdentifier("confirm-type")
                Button(action: add) { Text(.confirmAdd) }
                    .buttonStyle(.tomiSecondary)
                    .accessibilityIdentifier("confirm-add")
            }
            TypedItemOutcome(typing: typing, model: model)
        }
    }

    private func add() {
        Task {
            if let ingredient = await typing.resolve() {
                model.list.add(ingredient)
            }
        }
    }
}
