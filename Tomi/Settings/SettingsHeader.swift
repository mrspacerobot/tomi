import SwiftUI
import TomiCore

struct SettingsHeader: View {
    let currentProgress: ShownProgress?

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.gap) {
            HStack {
                Text(.guideSettings).textStyle(.showTitle).accessibilityIdentifier("show-settings-title")
                Spacer(minLength: ShowSize.gap)
                TomiHostHead().frame(width: MascotSize.home, height: MascotSize.home)
            }
            if let currentProgress {
                HomeProgressSection(shown: currentProgress)
            }
        }
    }
}

#Preview { SettingsHeader(currentProgress: .previewReturning()).background { ShowStage() } }
