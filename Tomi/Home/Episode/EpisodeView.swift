import SwiftUI
import TomiCore

struct EpisodeView: View {
    let data: EpisodeData
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                ShowBackButton { dismiss() }.accessibilityIdentifier("episode-back")
                EpisodeHeader(data: data)
                EpisodeLevels(data: data)
                HomeSkillDetails(skill: data.progress, ink: .stageMuted)
            }
            .padding(ShowSize.edge)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .background { ShowStage() }
    }
}

#Preview {
    if let first = HomeMenuPreviewData.options.first?.skills.first,
        let data = EpisodeData.find(
            first.id,
            options: HomeMenuPreviewData.options,
            snapshot: HomeMenuPreviewData.skills
        )
    {
        EpisodeView(data: data)
    }
}
