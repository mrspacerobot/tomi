import SwiftUI
import TomiCore

struct LevelDiamonds: View {
    let level: SnapshotLevel

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            ForEach(0..<diamonds, id: \.self) { index in
                Rectangle()
                    .fill(fill(index))
                    .frame(width: Spacing.small, height: Spacing.small)
                    .overlay(Rectangle().stroke(ColorRole.cobalt.color, lineWidth: RuleWeight.hairline))
                    .rotationEffect(.degrees(45))
                    .accessibilityHidden(true)
            }
        }
        // A square turned on its corner is wider than its frame: this keeps the last one inside the margin.
        .padding(.horizontal, Spacing.xxSmall)
        .accessibilityLabel(Text(.homeSkillCookProgress(level.cooks, level.cooksToComplete)))
    }

    /// One for each cook the server says completes the level. A number below zero draws none.
    private var diamonds: Int {
        max(level.cooksToComplete, 0)
    }

    /// A cook counted fills its diamond; one still to cook stays the colour of the paper.
    private func fill(_ index: Int) -> Color {
        if isComplete(index) {
            return ColorRole.cobalt.color
        }
        return ColorRole.paper.color
    }

    private func isComplete(_ index: Int) -> Bool {
        level.granted || level.complete || index < level.cooks
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background(ColorRole.paper.color)
    }
}
