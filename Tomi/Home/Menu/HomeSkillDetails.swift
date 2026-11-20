import SwiftUI
import TomiCore

struct HomeSkillDetails: View {
    let skill: HomeSkillProgress
    var ink = ColorRole.showMuted
    var showsSummary = true

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.compact) {
            if showsSummary, !skill.summary.isEmpty {
                Text(verbatim: skill.summary).textStyle(.showNote, color: ink)
            }
            if skill.progress?.status == .locked, let names = skill.missingPrerequisiteNames {
                Text(.homeSkillServedAfter(names.formatted(.list(type: .and))))
                    .textStyle(.showNote, color: ink)
            }
        }
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        ShowCard { HomeSkillDetails(skill: skill) }.background { ShowStage() }
    }
}
