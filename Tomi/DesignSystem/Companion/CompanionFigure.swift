import SwiftUI

/// One still frame of Tomi in a given pose. Tomi at rest fills the frame; a jump, thought dots or sparkles
/// spill past it. Decorative: callers give any words around it.
struct CompanionFigure: View {
    let pose: CompanionPose
    var appearance: CompanionAppearance = .tastingMenu

    var body: some View {
        let drawing = CompanionDrawing(pose: pose, palette: appearance.palette)
        CompanionOverflowLayout {
            Canvas { context, size in
                drawing.draw(in: context, size: size)
            }
        }
    }
}

#Preview {
    CompanionFigure(pose: CompanionState.thinking.stillPose)
        .frame(width: MascotSize.companion, height: MascotSize.companion)
        .background(ColorRole.paper.color)
}
