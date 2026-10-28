import SwiftUI
import TomiCore

/// The server's course order, each technique with the server's progress for it by its permanent id.
struct HomeSkillMenu: View {
    let options: [OptionCourse]
    /// The snapshot's skills. Nil before the first snapshot: every technique's progress is then unknown.
    let skills: [SnapshotSkill]?

    var body: some View {
        let menu = HomeMenuProgress.make(options: options, skills: skills)
        VStack(alignment: .leading, spacing: Spacing.large) {
            VStack(alignment: .leading, spacing: Spacing.xxSmall) {
                Text(.homeMenuTitle).textStyle(.displayM)
                Text(.homeMenuDescription).textStyle(.description)
            }
            ForEach(menu.courses) { course in
                HomeCourseSection(course: course)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("home-menu")
    }
}

#Preview {
    HomeSkillMenu(options: HomeMenuPreviewData.options, skills: HomeMenuPreviewData.skills)
        .padding()
        .background(ColorRole.paper.color)
}
