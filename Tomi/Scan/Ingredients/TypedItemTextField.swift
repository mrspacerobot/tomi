import SwiftUI

struct TypedItemTextField: View {
    @Binding var text: String
    let look: TypedItemLook
    let submit: () -> Void

    var body: some View {
        ShowCard {
            TextField(text: $text, prompt: prompt) { Text(look.prompt) }
                .textStyle(.showBody)
                .frame(minHeight: TouchTarget.minimum)
                .contentShape(.interaction, Rectangle())
                .onSubmit(submit)
                .accessibilityIdentifier(look.identifierPrefix + "-type")
        }
    }

    private var prompt: Text {
        Text(look.prompt).foregroundStyle(ColorRole.showMuted.color)
    }
}

#Preview {
    TypedItemTextField(text: .constant(""), look: .cupboard, submit: {})
        .padding()
        .background { ShowStage() }
}
