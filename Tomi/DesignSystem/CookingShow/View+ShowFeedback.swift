import SwiftUI

extension View {
    func showFeedback(_ haptic: ShowHaptic, trigger: some Equatable) -> some View {
        modifier(ShowFeedback(haptic: haptic, trigger: trigger))
    }
}
