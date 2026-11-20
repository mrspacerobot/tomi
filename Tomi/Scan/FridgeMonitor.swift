import SwiftUI

struct FridgeMonitor: View {
    let photo: CGImage
    var isReading = false

    var body: some View {
        Image(decorative: photo, scale: 1)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: FridgeMonitorSize.photo)
            .background(ColorRole.showSurface.color)
            .clipShape(.rect(cornerRadius: Radius.showMonitor))
            .overlay { if isReading { FridgeScanLine() } }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(.fridgePhotoLabel))
            .accessibilityIdentifier("fridge-photo-preview")
    }
}

#Preview {
    if let photo = JPEGConverter.preview(from: PhotoSource.fakePhoto) {
        FridgeMonitor(photo: photo, isReading: true).background { ShowStage() }
    }
}
