import SwiftUI

struct SignInHeader: View {
    var body: some View {
        VStack(spacing: ShowSize.rowGap) {
            ShowValance()
            SignInWords()
            ShowHostOnStage()
            ShowLowerThird(label: .openingStarring, title: .openingTonightChef)
                .padding(.horizontal, ShowStageSize.signInset)
        }
        .background { ShowDrapes() }
    }
}

#Preview("Morning") { SignInHeader().background { ShowStage() }.preferredColorScheme(.light) }
#Preview("Evening") {
    SignInHeader().background { ShowStage() }.preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
