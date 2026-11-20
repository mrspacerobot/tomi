import SwiftUI
import TomiCore

struct EpisodeLevelCard: View {
    let level: NamedLevel
    let progress: SnapshotLevel?

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.compact) {
                Text(.guideLevelName(level.number, level.name)).textStyle(.cardTitle)
                if let progress {
                    Text(words(for: progress)).textStyle(.showMeta)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func words(for progress: SnapshotLevel) -> LocalizedStringResource {
        if progress.complete { return .guideLevelComplete }
        if !progress.open { return .guideLevelLocked }
        return .guideLevelCooks(progress.cooks, progress.cooksToComplete)
    }
}

#Preview { EpisodeLevelCard(level: NamedLevel(number: 1, name: "Start"), progress: nil) }
