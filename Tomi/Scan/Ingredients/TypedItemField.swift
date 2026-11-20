import SwiftUI
import TomiCore

/// A field to type an ingredient. An ambiguous word shows the server's candidates to pick from.
/// What happens to the chosen ingredient is up to the screen: it is handed to `onAdd`.
struct TypedItemField: View {
    @Bindable var typing: TypedItemModel
    let look: TypedItemLook
    let onAdd: (NamedOption) -> Void
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            inputLayout {
                TypedItemTextField(text: $typing.text, look: look, submit: add)
                Button(action: add) { Text(.confirmAdd).padding(.horizontal, ShowSize.gap) }
                    .buttonStyle(ShowSecondaryButtonStyle())
                    .accessibilityIdentifier(look.identifierPrefix + "-add")
            }
            TypedItemOutcome(typing: typing, look: look, onAdd: onAdd)
        }
    }

    private var inputLayout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: ShowSize.compact))
        }
        return AnyLayout(HStackLayout(spacing: ShowSize.gap))
    }

    private func add() {
        Task {
            if let ingredient = await typing.resolve() {
                onAdd(ingredient)
            }
        }
    }
}

#Preview {
    TypedItemField(typing: TypedItemModel(api: FakeTomiAPI()), look: .cupboard) { _ in }
        .padding()
        .background { ShowStage() }
        .dynamicTypeSize(.accessibility5)
}
