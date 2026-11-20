import SwiftUI

/// Compact Tomi for the tab bar and small messages. It uses the same face and toque as the full host.
struct TomiHostHead: View {
    var state: CompanionState = .idle

    var body: some View {
        let drawing = CompanionDrawing(pose: state.stillPose, palette: .cookingShow)
        Canvas { context, size in drawing.drawHead(in: context, size: size) }
            .accessibilityHidden(true)
    }
}

#Preview("Morning") {
    TomiHostHead()
        .frame(width: MascotSize.showHead, height: MascotSize.showHead)
        .background { ShowStage() }
        .preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    TomiHostHead(state: .listening)
        .frame(width: MascotSize.showHead, height: MascotSize.showHead)
        .background { ShowStage() }
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.accessibility5)
}
