import SwiftUI
import TomiCore

/// A field to type an ingredient. An ambiguous word shows the server's candidates to pick from.
/// What happens to the chosen ingredient is up to the screen: it is handed to `onAdd`.
struct TypedItemField: View {
    @Bindable var typing: TypedItemModel
    let look: TypedItemLook
    let onAdd: (NamedOption) -> Void
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HStack(spacing: Spacing.small) {
                TextField(text: $typing.text) { Text(look.prompt) }
                    .textStyle(inputStyle)
                    .onSubmit(add)
                    .accessibilityIdentifier(look.identifierPrefix + "-type")
                Button(action: add) { Text(.confirmAdd) }
                    .buttonStyle(.tomiSecondary)
                    .accessibilityIdentifier(look.identifierPrefix + "-add")
            }
            TypedItemOutcome(typing: typing, look: look, onAdd: onAdd)
        }
    }

    private var inputStyle: TextStyle {
        if showStyle { return .showLede }
        return .body
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
        .background(ColorRole.paper.color)
        .dynamicTypeSize(.accessibility5)
}
