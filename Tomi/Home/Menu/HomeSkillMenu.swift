import SwiftUI
import TomiCore

/// The server's course order, paired with compatible local learning progress by permanent IDs.
struct HomeSkillMenu: View {
    let options: [OptionCourse]
    let catalog: SkillCatalog?
    let progress: CookProgress?

    var body: some View {
        let menu = HomeMenuProgress.make(options: options, catalog: catalog, progress: progress)
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
    HomeSkillMenu(
        options: HomeMenuPreviewData.options,
        catalog: HomeMenuPreviewData.catalog,
        progress: SavedProgressModel.previewWithProgress().summary?.skillProgress
    )
    .padding()
    .background(ColorRole.paper.color)
}
