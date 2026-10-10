import PhotosUI
import SwiftUI

/// The button that picks the fridge photo: from the cook's photos, or in a UI test launch the fixed photo.
/// It hands over JPEG bytes ready for the server.
struct FridgePhotoPicker: View {
    let source: PhotoSource
    let onPhoto: (Data) -> Void
    let onFailure: () -> Void
    @State private var item: PhotosPickerItem?

    var body: some View {
        switch source {
        case .fixed(let photo):
            Button { onPhoto(photo) } label: { Text(.scanPickPhoto) }
                .buttonStyle(.tomiPrimary)
                .accessibilityIdentifier("scan-pick-photo")
        case .photoLibrary:
            PhotosPicker(selection: $item, matching: .images) { Text(.scanPickPhoto) }
                .buttonStyle(.tomiPrimary)
                .accessibilityIdentifier("scan-pick-photo")
                .onChange(of: item) { _, picked in load(picked) }
        }
    }

    private func load(_ picked: PhotosPickerItem?) {
        guard let picked else {
            return
        }
        Task {
            do {
                guard let data = try await picked.loadTransferable(type: Data.self) else {
                    return onFailure()
                }
                onPhoto(try JPEGConverter.jpeg(from: data))
            } catch {
                onFailure()
            }
        }
    }
}
