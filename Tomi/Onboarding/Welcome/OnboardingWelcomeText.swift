import SwiftUI

struct OnboardingWelcomeText: View {
    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.compact) {
            Text(.openingHostHello).textStyle(.cardTitle).accessibilityAddTraits(.isHeader)
            Text(.openingHostPromise).textStyle(.showText)
            Text(.openingHostQuestions).textStyle(.showText, color: .showMuted)
        }
    }
}

#Preview { ShowCard { OnboardingWelcomeText() } }
