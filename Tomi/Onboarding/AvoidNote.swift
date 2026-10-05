import SwiftUI

/// The honest note under the list: what Tomi leaves out, and that he cannot read packaging.
struct AvoidNote: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(.onboardingAvoidNoteKicker)
                .textStyle(.label, color: .stampRed)
            Text(.onboardingAvoidNote)
                .textStyle(.description)
                .accessibilityIdentifier("onboarding-avoid-note")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.small)
        .background(ColorRole.wash.color)
    }
}

#Preview {
    AvoidNote()
        .padding()
        .background(ColorRole.paper.color)
}
