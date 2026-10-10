import SwiftUI

extension View {
    /// Asks the cook before a diet or an avoid item is taken away. Only their yes lets the server weaken it.
    func confirmRestrictionRemoval(isPresented: Binding<Bool>, confirm: @escaping () -> Void) -> some View {
        confirmationDialog(Text(.confirmRemovalTitle), isPresented: isPresented, titleVisibility: .visible) {
            Button(role: .destructive, action: confirm) { Text(.confirmRemovalYes) }
                .accessibilityIdentifier("confirm-removal-yes")
            Button(role: .cancel) {} label: { Text(.confirmRemovalNo) }
        } message: {
            Text(.confirmRemovalMessage)
        }
    }
}
