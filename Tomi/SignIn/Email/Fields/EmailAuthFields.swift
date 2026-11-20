import SwiftUI

struct EmailAuthFields: View {
    @Bindable var model: EmailAuthModel
    var editing: FocusState<EmailAuthField?>.Binding

    var body: some View {
        VStack(spacing: ShowSize.gap) {
            EmailAddressField(email: $model.email, editing: editing)
            if model.mode != .passwordRecovery {
                EmailPasswordField(password: $model.password, editing: editing, failed: model.passwordFailed)
            }
        }
    }
}

#Preview {
    @Previewable @FocusState var editing: EmailAuthField?
    EmailAuthFields(model: EmailAuthModel(flow: .preview()), editing: $editing).padding().background { ShowStage() }
}
