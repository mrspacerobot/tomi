import SwiftUI
import TomiCore

struct HomeSkillProgressMark: View {
    let skill: HomeSkillProgress

    var body: some View {
        if let progress = skill.progress {
            switch progress.status {
            case .mastered:
                Label {
                    Text(.guideLevelComplete)
                } icon: {
                    Image(systemName: "star.fill")
                }
                .textStyle(.showNote, color: .showChecked)
            case .served:
                HomeLevelMark(progress: progress)
            case .locked:
                Label {
                    Text(.guideLevelLocked)
                } icon: {
                    Image(systemName: "lock.fill")
                }
                .textStyle(.showNote)
            }
        }
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        ShowCard { HomeSkillProgressMark(skill: skill) }
    }
}
