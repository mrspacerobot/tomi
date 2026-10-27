import SwiftUI
import TomiCore

struct HomeCourseHeading: View {
    let course: HomeCourseProgress
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        layout {
            Text(course.title).textStyle(.title)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
            if !dynamicTypeSize.isAccessibilitySize { Spacer(minLength: Spacing.xSmall) }
            masteryCount
        }
    }

    private var layout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: Spacing.xxSmall))
        }
        return AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: Spacing.xSmall))
    }

    @ViewBuilder private var masteryCount: some View {
        if let count = course.masteredCount {
            Text(.homeCourseMastery(count, course.skillCount))
                .textStyle(.caption)
                .foregroundStyle(ColorRole.inkFaded.color)
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
