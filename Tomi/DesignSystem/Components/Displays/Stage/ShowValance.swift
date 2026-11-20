import SwiftUI

struct ShowValance: View {
    var body: some View {
        VStack(spacing: 0) {
            ShowCurtainFabric()
                .frame(height: ShowStageSize.valance)
            ColorRole.showGold.color.frame(height: RuleWeight.showRing)
        }
        .accessibilityHidden(true)
    }
}

#Preview("Morning") { ShowValance().preferredColorScheme(.light) }
#Preview("Evening") { ShowValance().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
