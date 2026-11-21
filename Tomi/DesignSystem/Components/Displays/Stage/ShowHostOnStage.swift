import SwiftUI

struct ShowHostOnStage: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ShowSpotlight()
                .fill(
                    .linearGradient(colors: [ColorRole.stageBeam.color, .clear], startPoint: .top, endPoint: .bottom)
                )
                .accessibilityHidden(true)
            ShowStageFloor()
            CompanionSlot(state: .idle, side: ShowStageSize.hero)
                .padding(.bottom, ShowStageSize.figureInset)
        }
    }
}

#Preview("Morning") { ShowHostOnStage().background { ShowStage() }.preferredColorScheme(.light) }
#Preview("Evening") {
    ShowHostOnStage().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
