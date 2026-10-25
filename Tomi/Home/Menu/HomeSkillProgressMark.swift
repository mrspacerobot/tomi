import SwiftUI
import TomiCore

struct HomeSkillProgressMark: View {
    let skill: HomeSkillProgress

    var body: some View {
        if let progress = skill.progress {
            switch progress.status {
            case .mastered:
                SkillStamp()
            case .served:
                HomeLevelMark(progress: progress)
            case .locked:
                EmptyView()
            }
        }
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background(ColorRole.paper.color)
    }
}
