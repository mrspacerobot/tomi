import SwiftUI

struct ShowCardGround: View {
    let radius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(ColorRole.showSurface.color)
            .shadow(color: ColorRole.showShadow.color, radius: ShowShadow.cardRadius, y: ShowShadow.cardOffset)
    }
}

#Preview("Morning") {
    ShowCardGround(radius: Radius.showCard).padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowCardGround(radius: Radius.showCard).padding().background { ShowStage() }
        .preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
