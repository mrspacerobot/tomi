import SwiftUI

struct ShowButtonGround: View {
    let pressed: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.showButton)
            .fill(ColorRole.showLip.color)
            .offset(y: ShowSize.buttonLip)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.showButton)
                    .fill(ColorRole.showRed.color)
                    .offset(y: offset)
            }
    }

    private var offset: CGFloat {
        if pressed { return ShowSize.buttonLip }
        return .zero
    }
}

#Preview("Morning") {
    Button(.onboardingContinue) {}.buttonStyle(ShowPrimaryButtonStyle())
        .padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    Button(.onboardingContinue) {}.buttonStyle(ShowPrimaryButtonStyle())
        .padding().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
