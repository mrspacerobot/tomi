import SwiftUI

struct ScanWaitingView: View {
    let stage: ScanStage
    var photo: CGImage?

    var body: some View {
        ScrollView {
            VStack(spacing: ShowSize.rowGap) {
                ShowLowerThird(title: .fridgeLive)
                if let photo, stage == .reading { FridgeMonitor(photo: photo, isReading: true) }
                TomiHostHead(state: .thinking).frame(width: MascotSize.notice, height: MascotSize.notice)
                Text(words).textStyle(.showTitle).accessibilityIdentifier("scan-waiting")
                ProgressView().tint(ColorRole.stageInk.color).accessibilityHidden(true)
            }
            .padding(ShowSize.edge)
        }
        .multilineTextAlignment(.center)
    }

    private var words: LocalizedStringResource {
        switch stage {
        case .finding: .scanFinding
        default: .scanReading
        }
    }
}

#Preview {
    ScanWaitingView(stage: .reading, photo: JPEGConverter.preview(from: PhotoSource.fakePhoto))
        .background { ShowStage() }
}
