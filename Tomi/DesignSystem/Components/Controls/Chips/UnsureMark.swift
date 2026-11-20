import SwiftUI

/// The question mark on a red disc that an unsure chip carries before its name (`.r-chip.q em`).
struct UnsureMark: View {
    @ScaledMetric(relativeTo: .callout) private var side: CGFloat = 20

    var body: some View {
        Circle()
            .fill(ColorRole.showRed.color)
            .frame(width: side, height: side)
            .overlay {
                Icon(.question, size: .mark)
                    .foregroundStyle(ColorRole.showWhite.color)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    UnsureMark()
        .padding()
        .background { ShowStage() }
}
