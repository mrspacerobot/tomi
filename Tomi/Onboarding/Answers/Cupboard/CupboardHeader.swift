import SwiftUI

/// A heading inside the cupboard question.
struct CupboardHeader: View {
    @Environment(\.usesShowQuestionStyle) private var showStyle
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
            .textStyle(headingStyle)
            .textCase(.uppercase)
            .accessibilityAddTraits(.isHeader)
    }
    private var headingStyle: TextStyle {
        if showStyle { return .showLabel }
        return .label
    }
}

#Preview {
    CupboardHeader(title: .questionCupboardStaples)
        .padding()
        .background(ColorRole.paper.color)
}
