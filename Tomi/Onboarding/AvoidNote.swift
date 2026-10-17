import SwiftUI

/// A calm note under the avoid question: Tomi cannot read a label for the cook.
struct AvoidNote: View {
    var body: some View {
        Text(.questionAvoidNote)
            .textStyle(.description)
            .padding(.top, Spacing.medium)
            .padding(.horizontal, Spacing.screenMargin + TickRowFace.contentInset)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AvoidNote()
        .background(ColorRole.paper.color)
        .dynamicTypeSize(.accessibility5)
}
