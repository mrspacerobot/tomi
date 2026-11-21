import SwiftUI

/// The cook picks the fridge photo, or types instead.
struct ScanReadyView: View {
    let model: ScanModel
    let photos: PhotoSource

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                ShowLowerThird(title: .fridgeLive).accessibilityIdentifier("fridge-live-label")
                ScanHeader(title: .scanReadyTitle, identifier: "scan-ready-title", problem: model.problem)
                FridgeReadyHost()
                FridgePhotoPicker(source: photos, onPhoto: send, onFailure: model.photoFailed)
                Button(action: model.typeInstead) { Text(.scanTypeInstead).textStyle(.showLede) }
                    .frame(minHeight: TouchTarget.minimum)
                    .accessibilityIdentifier("scan-type-instead")
            }
            .padding(ShowSize.edge)
        }
    }

    private func send(_ jpeg: Data) {
        Task { await model.send(jpeg: jpeg) }
    }
}

#Preview {
    ScanReadyView(model: .preview(), photos: .fixed(PhotoSource.fakePhoto))
        .background { ShowStage() }
}
