import SwiftUI

struct ShowDrapes: View {
    var body: some View {
        HStack(spacing: 0) {
            ShowCurtainFabric()
                .frame(width: ShowStageSize.drape)
                .clipShape(.rect(bottomTrailingRadius: Radius.showSheet))
            Spacer(minLength: 0)
            ShowCurtainFabric()
                .frame(width: ShowStageSize.drape)
                .clipShape(.rect(bottomLeadingRadius: Radius.showSheet))
        }
        .frame(maxWidth: .infinity)
        .accessibilityHidden(true)
    }
}

#Preview("Morning") { ShowDrapes().preferredColorScheme(.light) }
#Preview("Evening") { ShowDrapes().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5) }
