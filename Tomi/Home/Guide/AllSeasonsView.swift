import SwiftUI
import TomiCore

struct AllSeasonsView: View {
    let options: [OptionCourse]
    let skills: [SnapshotSkill]?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                ShowBackButton { dismiss() }.accessibilityIdentifier("seasons-back")
                HomeSkillMenu(options: options, skills: skills, titleIdentifier: "all-seasons-title")
            }
            .padding(ShowSize.edge)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .background { ShowStage() }
    }
}

#Preview {
    AllSeasonsView(options: HomeMenuPreviewData.options, skills: HomeMenuPreviewData.skills)
}
