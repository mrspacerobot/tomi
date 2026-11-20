import SwiftUI

struct OnboardingWelcomeTomi: View {
    var body: some View {
        VStack(spacing: ShowSize.rowGap) {
            ShowValance()
            ShowMarquee(title: .openingMeetHost)
                .padding(.horizontal, ShowStageSize.signInset)
            ShowHostOnStage()
        }
    }
}

#Preview { OnboardingWelcomeTomi().background { ShowStage() } }
