import SwiftUI

/// The double rule that opens a block: two cobalt hairlines, three points from top to bottom.
struct DoubleRule: View {
    var body: some View {
        VStack(spacing: RuleWeight.double - 2 * RuleWeight.hairline) {
            Hairline(.cobalt)
            Hairline(.cobalt)
        }
    }
}

#Preview {
    DoubleRule()
        .padding()
        .background(ColorRole.paper.color)
}
