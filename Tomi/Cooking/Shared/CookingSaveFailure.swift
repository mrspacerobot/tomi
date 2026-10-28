import SwiftUI

/// A failed write stays on the cooking screen until the cook can try the same save again.
struct CookingSaveFailure: ViewModifier {
    @Binding var showing: Bool
    let retry: () -> Void

    func body(content: Content) -> some View {
        content.alert(Text(.cookingSaveFailedTitle), isPresented: $showing) {
            Button(.cookingSaveFailedRetry, action: retry)
            Button(.cookingSaveFailedStay, role: .cancel) {}
        } message: {
            Text(.cookingSaveFailedMessage)
        }
    }
}
