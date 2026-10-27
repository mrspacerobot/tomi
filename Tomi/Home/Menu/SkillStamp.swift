import SwiftUI
import TomiCore

struct SkillStamp: View {
    var body: some View {
        ZStack {
            Circle().stroke(ColorRole.stampRedMark.color, lineWidth: RuleWeight.double)
            Circle().stroke(
                ColorRole.stampRedMark.color,
                style: StrokeStyle(lineWidth: RuleWeight.hairline, dash: [RuleWeight.hairline, RuleWeight.leader])
            )
            .padding(Spacing.xxSmall)
            Image(systemName: "seal.fill")
                .imageScale(.small)
                .foregroundStyle(ColorRole.stampRedMark.color)
        }
        .frame(width: Spacing.large, height: Spacing.large)
        .accessibilityLabel(Text(.homeSkillMastered))
    }
}

#Preview {
    if let skill = HomeMenuPreviewData.menu?.courses.first?.skills.first {
        HomeSkillRow(skill: skill)
            .padding()
            .background(ColorRole.paper.color)
    }
}
