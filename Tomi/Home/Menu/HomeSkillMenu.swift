import SwiftUI
import TomiCore

/// Joins the server catalog and snapshot. Home can focus on the season the snapshot names.
struct HomeSkillMenu: View {
    let options: [OptionCourse]
    let skills: [SnapshotSkill]?
    var focus: SkillID?
    var titleIdentifier = "home-season-title"
    var includesTitle = true

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.rowGap) {
            if includesTitle {
                Text(.guideAllSeasons).textStyle(.showTitle).accessibilityIdentifier(titleIdentifier)
            }
            ForEach(courses) { course in
                HomeCourseSection(course: course)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("home-menu")
    }

    private var courses: [HomeCourseProgress] {
        let menu = HomeMenuProgress.make(options: options, skills: skills).courses
        guard let focus, let season = menu.first(where: { $0.skills.contains(where: { $0.id == focus }) }) else {
            return menu
        }
        return [season]
    }
}

#Preview {
    HomeSkillMenu(options: HomeMenuPreviewData.options, skills: HomeMenuPreviewData.skills)
        .padding().background { ShowStage() }
}
