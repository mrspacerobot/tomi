import SwiftUI

struct ShowBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .font(.system(size: ShowSize.backIcon, weight: .bold))
                .foregroundStyle(ColorRole.stageInk.color)
                .frame(width: TouchTarget.minimum, height: TouchTarget.minimum)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(.onboardingBack))
    }
}

#Preview("Morning") {
    ShowBackButton(action: {}).padding().background { ShowStage() }.preferredColorScheme(.light)
}

#Preview("Evening, largest text") {
    ShowBackButton(action: {}).padding().background { ShowStage() }
        .preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
