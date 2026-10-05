import SwiftUI
import TomiCore

@testable import Tomi

extension ColorRole {
    /// The colour the asset catalog gives this role in a light or a dark appearance.
    @MainActor func rgb(in scheme: ColorScheme) -> RGBColor {
        var environment = EnvironmentValues()
        environment.colorScheme = scheme
        let resolved = color.resolve(in: environment)
        return RGBColor(red: Double(resolved.red), green: Double(resolved.green), blue: Double(resolved.blue))
    }
}
