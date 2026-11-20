import SwiftUI

/// One segment of a progress rule. A segment that is done is a thick red bar; one still to come leaves
/// only the hairline that runs through the whole rule, so done and to come differ in weight and not only
/// in colour.
struct ProgressSegment: View {
    let isDone: Bool
    /// Every segment but the first is parted from the one before it by a short gap.
    let isFirst: Bool

    var body: some View {
        Rectangle()
            .fill(fill)
            .overlay(alignment: .leading) {
                if !isFirst {
                    Rectangle()
                        .fill(ColorRole.stage.color)
                        .frame(width: RuleWeight.hairline)
                }
            }
    }

    private var fill: Color {
        if isDone {
            return ColorRole.showAccent.color
        }
        return .clear
    }
}

#Preview {
    HStack(spacing: 0) {
        ProgressSegment(isDone: true, isFirst: true)
        ProgressSegment(isDone: true, isFirst: false)
        ProgressSegment(isDone: false, isFirst: false)
    }
    .frame(height: RuleWeight.double)
    .padding()
    .background { ShowStage() }
}
