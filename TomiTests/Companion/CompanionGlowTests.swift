import SwiftUI
import Testing

@testable import Tomi

/// On paper a glow only blurs Tomi's outline, so it is clear there; on night ink it lifts him off the ground.
struct CompanionGlowTests {
    @Test @MainActor func theGlowIsClearOnPaperAndWarmOnNightInk() {
        #expect(opacity(in: .light) == 0)
        #expect(opacity(in: .dark) > 0.9)
    }

    @MainActor private func opacity(in scheme: ColorScheme) -> Float {
        var environment = EnvironmentValues()
        environment.colorScheme = scheme
        return ColorRole.companionGlow.color.resolve(in: environment).opacity
    }
}
