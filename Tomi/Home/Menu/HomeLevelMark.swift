import SwiftUI
import TomiCore

struct HomeLevelMark: View {
    let progress: SkillProgress

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            Text(.homeSkillLevel(progress.currentLevel)).textStyle(.status)
            if let level = progress.levels.first(where: { $0.number == progress.currentLevel }) {
                LevelDiamonds(level: level)
            }
        }
        .foregroundStyle(ColorRole.inkFaded.color)
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background(ColorRole.paper.color)
    }
}
