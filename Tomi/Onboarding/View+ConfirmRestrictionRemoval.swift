import SwiftUI

extension View {
    /// Only the explicit confirmation lets the server weaken restrictions.
    func confirmRestrictionRemoval(isPresented: Binding<Bool>, confirm: @escaping () -> Void) -> some View {
        sheet(isPresented: isPresented) { RestrictionRemovalSheet(confirm: confirm) }
    }
}
