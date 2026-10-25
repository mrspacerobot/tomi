import SwiftUI
import TomiCore

struct LevelDiamonds: View {
    let level: LevelProgress

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            ForEach(0..<GameRules.cooksToCompleteLevel, id: \.self) { index in
                Rectangle()
                    .fill(isComplete(index) ? ColorRole.cobalt.color : ColorRole.paper.color)
                    .frame(width: Spacing.small, height: Spacing.small)
                    .overlay(Rectangle().stroke(ColorRole.cobalt.color, lineWidth: RuleWeight.hairline))
                    .rotationEffect(.degrees(45))
                    .accessibilityHidden(true)
            }
        }
        .accessibilityLabel(Text(.homeSkillCookProgress(level.cooks, GameRules.cooksToCompleteLevel)))
    }

    private func isComplete(_ index: Int) -> Bool {
        level.isGranted || index < level.cooks
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background(ColorRole.paper.color)
    }
}
