import SwiftUI
import TomiCore

struct HomeSkillRow: View {
    let skill: HomeSkillProgress

    var body: some View {
        NavigationLink(value: HomeRoute.episode(skill.id)) {
            ShowCard {
                VStack(alignment: .leading, spacing: ShowSize.compact) {
                    HomeSkillNameLine(skill: skill)
                    HomeSkillDetails(skill: skill)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("home-skill-" + skill.id.rawValue)
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        NavigationStack { HomeSkillRow(skill: skill).padding().background { ShowStage() } }
    }
}
