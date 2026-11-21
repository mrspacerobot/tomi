import SwiftUI
import TomiCore

struct HomeLevelMark: View {
    let progress: SnapshotSkill

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            Text(.homeSkillLevel(progress.currentLevel)).textStyle(.showNote)
            if let level = progress.levelInProgress {
                Text(.guideLevelCooks(level.cooks, level.cooksToComplete)).textStyle(.showNote)
            }
        }

    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background { ShowStage() }
    }
}
