import SwiftUI

/// The small heading over a group of tick rows. It lines up with the words of the rows under it.
struct AvoidGroupHeader: View {
    @Environment(\.usesShowQuestionStyle) private var showStyle
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
            .textStyle(headingStyle)
            .padding(.top, Spacing.large)
            .padding(.horizontal, Spacing.screenMargin + TickRowFace.contentInset)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
    private var headingStyle: TextStyle {
        if showStyle { return .showLabel }
        return .label
    }
}

#Preview {
    AvoidGroupHeader(title: .questionAvoidGroupAllergens)
        .background(ColorRole.paper.color)
        .dynamicTypeSize(.accessibility5)
}
