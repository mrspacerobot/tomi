import SwiftUI

/// Start the fresh-profile checked preparation or return to the same suggestion.
struct CookingIntroductionActions: View {
    let model: CookingIntroductionModel
    let start: () -> Void
    let close: () -> Void

    var body: some View {
        VStack(spacing: Spacing.small) {
            Button(action: start) {
                Text(model.isRefreshingProfile ? .cookingCheckingProfile : .cookingStart)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(ShowPrimaryButtonStyle())
            .disabled(!model.suggestion.canOfferTeaching || model.isRefreshingProfile)
            .accessibilityIdentifier("cooking-start")
            Button(action: close) { Text(.cookingNotTonight).frame(maxWidth: .infinity) }
                .buttonStyle(ShowSecondaryButtonStyle())
                .accessibilityIdentifier("cooking-not-tonight")
        }
    }
}
