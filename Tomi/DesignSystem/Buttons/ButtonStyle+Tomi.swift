import SwiftUI

extension ButtonStyle where Self == TomiButtonStyle {
    /// The filled button, for the one next thing to do on a screen.
    static var tomiPrimary: TomiButtonStyle {
        TomiButtonStyle(kind: .primary)
    }

    /// The outlined button, for the other things a cook can do.
    static var tomiSecondary: TomiButtonStyle {
        TomiButtonStyle(kind: .secondary)
    }
}
