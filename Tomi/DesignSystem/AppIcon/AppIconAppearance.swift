import SwiftUI

/// The three looks iOS asks of an app icon: on a light home screen, on a dark one, and tinted in the cook's
/// chosen colour.
nonisolated enum AppIconAppearance: CaseIterable, Sendable {
    case light, dark, tinted

    /// The scheme the design tokens are read in. The tinted icon starts from the dark one, because iOS tints
    /// a light figure on a dark ground.
    var colorScheme: ColorScheme {
        switch self {
        case .light: .light
        case .dark, .tinted: .dark
        }
    }

    /// How much colour is taken out: iOS colours the tinted icon itself from its grey levels.
    var grayscale: Double {
        switch self {
        case .light, .dark: 0
        case .tinted: 1
        }
    }
}
