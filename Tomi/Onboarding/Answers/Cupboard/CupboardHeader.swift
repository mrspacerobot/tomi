import SwiftUI

/// A heading inside the cupboard question.
struct CupboardHeader: View {
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
            .textStyle(.showLabel)
            .textCase(.uppercase)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    CupboardHeader(title: .questionCupboardStaples)
        .padding()
        .background { ShowStage() }
}
