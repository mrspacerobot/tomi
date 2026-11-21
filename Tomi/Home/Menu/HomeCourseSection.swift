import SwiftUI
import TomiCore

struct HomeCourseSection: View {
    let course: HomeCourseProgress

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HomeCourseHeading(course: course)
                .accessibilityElement(children: .combine)
                .accessibilityIdentifier("home-course-" + course.id.rawValue)
            ForEach(course.skills) { skill in
                HomeSkillRow(skill: skill)
            }
        }
    }
}

#Preview {
    if let course = HomeMenuPreviewData.menu?.courses.first {
        HomeCourseSection(course: course)
            .padding()
            .background(ColorRole.paper.color)
    }
}
