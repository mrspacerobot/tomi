import SwiftUI

struct EpisodeHeader: View {
    let data: EpisodeData

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.gap) {
            Text(verbatim: data.course.title).textStyle(.showLabel)
            Text(verbatim: data.option.name)
                .textStyle(.showTitle)
                .accessibilityIdentifier("episode-title")
            HStack(spacing: ShowSize.gap) {
                Text(verbatim: data.option.summary).textStyle(.showLede)
                TomiHostHead(state: .explaining).frame(width: MascotSize.home, height: MascotSize.home)
            }
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
        EpisodeHeader(data: data).background { ShowStage() }
    }
}
