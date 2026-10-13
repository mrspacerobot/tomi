import PhotosUI
import SwiftUI

/// The button that picks the fridge photo: from the cook's photos, or in a UI test launch the fixed photo.
/// It hands over JPEG bytes for the server, with the photo's place and time only if the cook agreed to keeping it.
struct FridgePhotoPicker: View {
    let source: PhotoSource
    let keepsMetadata: Bool
    let onPhoto: (Data) -> Void
    let onFailure: () -> Void
    @State private var item: PhotosPickerItem?

    var body: some View {
        switch source {
        case .fixed(let photo):
            Button {
                onPhoto(photo)
            } label: {
                Text(.scanPickPhoto)
            }
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
                onPhoto(try await Self.jpeg(of: picked, keepingMetadata: keepsMetadata))
            } catch {
                onFailure()
            }
        }
    }

    private static func jpeg(of picked: PhotosPickerItem, keepingMetadata: Bool) async throws -> Data {
        guard let data = try await picked.loadTransferable(type: Data.self) else {
            throw JPEGConversionError.unreadable
        }
        return try JPEGConverter.jpeg(from: data, keepingMetadata: keepingMetadata)
    }
}
