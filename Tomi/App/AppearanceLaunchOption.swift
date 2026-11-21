import SwiftUI

/// What the launch arguments say about light and dark. UI tests pass them, because this simulator ignores
/// `XCUIDevice.appearance`; a cook never does, and then the app follows the phone.
nonisolated enum AppearanceLaunchOption {
    static let darkArgument = "--appearance-dark"
    static let lightArgument = "--appearance-light"

    /// The appearance to force, or nil to follow the phone.
    static func colorScheme(in arguments: [String]) -> ColorScheme? {
        if arguments.contains(darkArgument) {
            return .dark
        }
        if arguments.contains(lightArgument) {
            return .light
        }
        return nil
    }
}
