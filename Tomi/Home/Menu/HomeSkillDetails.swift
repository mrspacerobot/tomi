import SwiftUI
import TomiCore

struct HomeSkillDetails: View {
    let skill: HomeSkillProgress

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            if !skill.summary.isEmpty {
                Text(skill.summary).textStyle(.description)
                    .foregroundStyle(ColorRole.inkFaded.color)
            }
            lockedExplanation
        }
    }

    @ViewBuilder private var lockedExplanation: some View {
        if case .locked = skill.progress?.status, let names = skill.missingPrerequisiteNames {
            Text(.homeSkillServedAfter(names.formatted(.list(type: .and))))
                .textStyle(.description)
                .foregroundStyle(ColorRole.inkFaded.color)
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
