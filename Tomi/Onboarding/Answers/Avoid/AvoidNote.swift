import SwiftUI

/// A calm note under the avoid question: Tomi cannot read a label for the cook.
struct AvoidNote: View {
    var body: some View {
        Text(.questionAvoidNote)
            .textStyle(.showLede)
            .padding(.top, Spacing.medium)
            .padding(.horizontal, ShowSize.edge)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AvoidNote()
        .background { ShowStage() }
        .dynamicTypeSize(.accessibility5)
}
