import SwiftUI

struct EmailAuthSubmitButton: View {
    let model: EmailAuthModel
    let action: () -> Void

    var body: some View {
        Button(action: action) { Text(model.mode.submitTitle) }
            .buttonStyle(ShowPrimaryButtonStyle())
            .disabled(!model.canSubmit)
            .accessibilityIdentifier(model.mode.submitIdentifier)
    }
}

#Preview { EmailAuthSubmitButton(model: EmailAuthModel(flow: .preview()), action: {}) }
