import SwiftUI
import TomiCore

struct HomeSkillNameLine: View {
    let skill: HomeSkillProgress
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        layout {
            Text(skill.name).textStyle(.cardTitle)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
            if !dynamicTypeSize.isAccessibilitySize { Spacer(minLength: ShowSize.gap) }
            HomeSkillProgressMark(skill: skill)
        }
    }

    private var layout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: Spacing.xxSmall))
        }
        return AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: Spacing.xSmall))
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background { ShowStage() }
    }
}
