import SwiftUI
import Testing

@testable import Tomi

/// The launch arguments UI tests pass to see the app in light or dark without relying on the phone's setting.
@Suite struct AppearanceLaunchOptionTests {
    @Test func withoutArgumentsTheAppFollowsThePhone() {
        #expect(AppearanceLaunchOption.colorScheme(in: ["Tomi"]) == nil)
    }

    @Test func eachArgumentForcesItsAppearance() {
        #expect(AppearanceLaunchOption.colorScheme(in: ["--appearance-dark"]) == .dark)
        #expect(AppearanceLaunchOption.colorScheme(in: ["--appearance-light"]) == .light)
    }

    /// When a test passes both by mistake, the answer must not depend on their order.
    @Test func ofBothTheDarkOneWinsInAnyOrder() {
        #expect(AppearanceLaunchOption.colorScheme(in: ["--appearance-light", "--appearance-dark"]) == .dark)
        #expect(AppearanceLaunchOption.colorScheme(in: ["--appearance-dark", "--appearance-light"]) == .dark)
    }
}
