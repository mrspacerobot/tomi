import SwiftUI

/// The small heading over a group of tick rows. It lines up with the words of the rows under it.
struct AvoidGroupHeader: View {
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
            .textStyle(.label)
            .padding(.top, Spacing.large)
            .padding(.horizontal, Spacing.screenMargin + TickRowFace.contentInset)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    AvoidGroupHeader(title: .questionAvoidGroupAllergens)
        .background(ColorRole.paper.color)
        .dynamicTypeSize(.accessibility5)
}
