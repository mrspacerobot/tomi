import SwiftUI

struct SettingsEditHeader: View {
    let back: () -> Void

    var body: some View {
        HStack {
            ShowBackButton(action: back)
            ShowLowerThird(title: .guideSettings)
        }
    }
}

#Preview { SettingsEditHeader(back: {}).background { ShowStage() } }
