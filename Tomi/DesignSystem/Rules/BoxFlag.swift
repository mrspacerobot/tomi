import SwiftUI

/// The red label set into the top edge of a double-ruled box, breaking the outline behind it.
struct BoxFlag: View {
    /// The paper kept clear on each side of the words (`.b-special .flag`).
    static let sidePadding: CGFloat = 10

    let words: LocalizedStringResource

    var body: some View {
        Text(words)
            .textStyle(.label, color: .stampRed)
            .multilineTextAlignment(.center)
            .padding(.horizontal, Self.sidePadding)
            .background(ColorRole.paper.color)
    }
}

#Preview {
    BoxFlag(words: .sampleBoxFlag)
        .padding()
        .background(ColorRole.wash.color)
}
