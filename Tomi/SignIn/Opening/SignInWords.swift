import SwiftUI

struct SignInWords: View {
    var body: some View {
        ShowMarquee(title: .openingShowTitle, kicker: .openingShowKicker)
            .padding(.horizontal, ShowStageSize.signInset)
            .accessibilityIdentifier("sign-in-title")
    }
}

#Preview { SignInWords() }
