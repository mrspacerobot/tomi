import SwiftUI

/// The cook picks the fridge photo, or types instead.
struct ScanReadyView: View {
    let model: ScanModel
    let photos: PhotoSource

    var body: some View {
        VStack(spacing: Spacing.large) {
            Text(.scanReadyTitle)
                .textStyle(.displayL)
                .accessibilityIdentifier("scan-ready-title")
            if let problem = model.problem {
                ProblemView(problem: problem)
            }
            FridgePhotoPicker(source: photos, onPhoto: send, onFailure: model.photoFailed)
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
