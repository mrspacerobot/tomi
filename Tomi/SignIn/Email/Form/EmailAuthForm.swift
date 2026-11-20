import SwiftUI

struct EmailAuthForm: View {
    let model: EmailAuthModel
    @FocusState private var editing: EmailAuthField?

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.gap) {
            Text(model.mode.pageTitle).textStyle(.showTitle).accessibilityAddTraits(.isHeader)
            EmailAuthFields(model: model, editing: $editing).disabled(model.isSubmitting)
            EmailAuthNotice(model: model)
            EmailAuthModeActions(model: model).disabled(model.isSubmitting)
            EmailAuthPortrait(hasProblem: model.noticeIsError)
            EmailAuthSubmitButton(model: model, action: submit)
        }
    }

    private func submit() {
        editing = nil
        Task { await model.submit() }
    }
}

#Preview {
    EmailAuthForm(model: EmailAuthModel(flow: .preview())).padding().background { ShowStage() }
}
