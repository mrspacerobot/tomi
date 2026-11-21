import SwiftUI

struct ConfirmHeading: View {
    let model: ScanModel

    var body: some View {
        if let photo = model.previewPhoto {
            ScanHeader(title: .fridgeLineUp, identifier: "confirm-title", problem: model.problem)
            FridgeMonitor(photo: photo)
        } else {
            ScanHeader(title: .fridgeTellMe, identifier: "confirm-title", problem: model.problem)
            ShowSpeechBubble { Text(.fridgeTypedInvitation) }
                .padding(.leading, ShowSize.gap)
        }
    }
}

#Preview { ConfirmHeading(model: .preview()).padding().background { ShowStage() } }
