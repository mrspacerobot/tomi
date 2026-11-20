import SwiftUI

/// The morning or evening stage lighting, under both the content and the safe areas.
struct ShowStage: View {
    var body: some View {
        EllipticalGradient(
            stops: [
                .init(color: ColorRole.stageGlow.color, location: 0),
                .init(color: ColorRole.stage.color, location: 0.7),
            ],
            center: .top,
            endRadiusFraction: 0.9
        )
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

#Preview("Morning") { ShowStage().preferredColorScheme(.light) }
#Preview("Evening, largest text") { ShowStage().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
