import SwiftUI

/// The top of every onboarding question: Back, the segmented rule and the word "Required".
struct OnboardingHeader: View {
    /// The header is chrome, not reading: past this size the words would push the progress rule away.
    static let largestSize = DynamicTypeSize.xxxLarge

    let completed: Int
    let total: Int
    let back: () -> Void

    var body: some View {
        HStack(spacing: Spacing.small) {
            Button(action: back) {
                Icon(.back, size: .medium)
                    .frame(width: TouchTarget.minimum, height: TouchTarget.minimum)
            }
            .accessibilityLabel(Text(.onboardingBack))
            .accessibilityIdentifier("onboarding-back")
            ProgressRule(completed: completed, total: total)
            Text(.onboardingRequired)
                .textStyle(.label, color: .stampRed)
                .lineLimit(1)
        }
        .padding(.leading, Spacing.xSmall)
        .padding(.trailing, Spacing.screenMargin)
        .dynamicTypeSize(...Self.largestSize)
    }
}

#Preview {
    OnboardingHeader(completed: 2, total: 6, back: {})
        .background(ColorRole.paper.color)
}
