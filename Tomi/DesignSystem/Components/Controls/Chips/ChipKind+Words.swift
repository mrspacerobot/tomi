import SwiftUI

/// What VoiceOver says for each state of a chip, so the state is never carried by the drawing alone.
extension ChipKind {
    /// The name of the chip. A chip that a tap removes says so, since its cross is not read.
    func label(for name: String) -> Text {
        if isRemovable {
            return Text(.chipRemoveLabel(name))
        }
        return Text(name)
    }

    /// The state, read after the name. Empty for on and off, which VoiceOver reads as selected or not.
    var value: Text {
        switch self {
        case .locked: Text(.chipLockedValue)
        case .offTonight: Text(.chipOffTonightValue)
        case .unsure: Text(.chipUnsureValue)
        case .on, .off, .removable: Text(verbatim: "")
        }
    }
}
