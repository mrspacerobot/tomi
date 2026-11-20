import SwiftUI

/// A calm note under the avoid question: Tomi cannot read a label for the cook.
struct AvoidNote: View {
    @Environment(\.usesShowQuestionStyle) private var showStyle
    var body: some View {
        Text(.questionAvoidNote)
            .textStyle(noteStyle)
            .padding(.top, Spacing.medium)
            .padding(.horizontal, Spacing.screenMargin + TickRowFace.contentInset)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var noteStyle: TextStyle {
        if showStyle { return .showLede }
        return .description
    }
}

#Preview {
    AvoidNote()
        .background(ColorRole.paper.color)
        .dynamicTypeSize(.accessibility5)
}
