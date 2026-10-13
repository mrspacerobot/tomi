import SwiftUI

/// The cook picks the fridge photo, or types instead.
struct ScanReadyView: View {
    let model: ScanModel
    let photos: PhotoSource

    var body: some View {
        VStack(spacing: Spacing.large) {
            ScanHeader(title: .scanReadyTitle, identifier: "scan-ready-title", problem: model.problem)
            FridgePhotoPicker(
                source: photos,
                keepsMetadata: model.keepsPhoto,
                onPhoto: send,
                onFailure: model.photoFailed
            )
            Button(action: model.typeInstead) { Text(.scanTypeInstead) }
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("scan-type-instead")
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.screenMargin)
    }

    private func send(_ jpeg: Data) {
        Task { await model.send(jpeg: jpeg) }
    }
}

#Preview {
    ScanReadyView(model: .preview(), photos: .fixed(PhotoSource.fakePhoto))
        .background(ColorRole.paper.color)
}
