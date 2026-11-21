import SwiftUI

struct RestrictionRemovalSheet: View {
    let confirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                Text(.confirmRemovalTitle).textStyle(.showTitle)
                ShowSpeechBubble { Text(.confirmRemovalMessage) }
                RestrictionRemovalActions(cancel: { dismiss() }, confirm: confirmed)
            }
            .padding(ShowSize.edge)
        }
        .background { ShowStage() }
        .presentationDetents([.medium, .large])
    }

    private func confirmed() {
        dismiss()
        confirm()
    }
}

#Preview { RestrictionRemovalSheet(confirm: {}) }
