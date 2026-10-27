import SwiftUI

/// The refusal shown when a check before cooking is not passed. Acknowledging it sends the cook back to the start,
/// so nothing of the scan that was checked stays reachable: new suggestions are needed.
struct CookingStartAlert: ViewModifier {
    @Binding var refusal: CookingIntroductionRefusal?
    @Binding var path: [HomeRoute]

    func body(content: Content) -> some View {
        content.alert(item: $refusal) { _ in
            Alert(
                title: Text(.cookingRefreshRefusedTitle),
                message: Text(.cookingRefreshRefusedMessage),
                dismissButton: .default(Text(.commonOkay), action: startOver)
            )
        }
    }

    private func startOver() {
        path.removeAll()
    }
}

extension View {
    func cookingStartAlert(_ refusal: Binding<CookingIntroductionRefusal?>, path: Binding<[HomeRoute]>) -> some View {
        modifier(CookingStartAlert(refusal: refusal, path: path))
    }
}
