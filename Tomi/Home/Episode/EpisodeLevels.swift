import SwiftUI

struct EpisodeLevels: View {
    let data: EpisodeData

    var body: some View {
        ForEach(data.option.levels, id: \.number) { level in
            EpisodeLevelCard(
                level: level,
                progress: data.progress.progress?.levels.first { $0.number == level.number }
            )
        }
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
        EpisodeLevels(data: data).background { ShowStage() }
    }
}
