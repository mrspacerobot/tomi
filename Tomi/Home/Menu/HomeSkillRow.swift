import SwiftUI
import TomiCore

struct HomeSkillRow: View {
    let skill: HomeSkillProgress

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            HomeSkillNameLine(skill: skill)
            HomeSkillDetails(skill: skill)
            Hairline()
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("home-skill-" + skill.id.rawValue)
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background(ColorRole.paper.color)
    }
}
