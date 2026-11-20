import SwiftUI

/// What the cook has tonight: tick what is really there, untick what is not, type what the photo missed.
/// Unsure items start unticked and only count once the cook ticks them.
struct ConfirmView: View {
    let model: ScanModel
    @State private var typing: TypedItemModel

    init(model: ScanModel) {
        self.model = model
        _typing = State(initialValue: TypedItemModel(api: model.api))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                ConfirmHeading(model: model)
                ConfirmChips(model: model)
                TypedItemField(typing: typing, look: .confirm) { model.list.add($0) }
                FindSuggestionsButton(model: model)
            }
            .padding(ShowSize.edge)
        }
        .scrollDismissesKeyboard(.interactively)
        .environment(\.usesShowQuestionStyle, true)
    }
}

#Preview {
    ConfirmView(model: .preview())
        .background { ShowStage() }
}
