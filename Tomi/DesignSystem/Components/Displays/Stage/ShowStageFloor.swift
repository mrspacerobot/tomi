import SwiftUI

struct ShowStageFloor: View {
    var body: some View {
        Ellipse().fill(.ellipticalGradient(colors: [ColorRole.stageFloor.color, ColorRole.stageFloorEdge.color]))
            .frame(height: ShowStageSize.floor)
            .accessibilityHidden(true)
    }
}

#Preview("Morning") { ShowStageFloor().preferredColorScheme(.light) }
#Preview("Evening") { ShowStageFloor().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
