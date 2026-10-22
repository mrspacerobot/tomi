import Foundation

@testable import Tomi

extension AppIconAppearance {
    /// The app icon set in the asset catalog, found from this file, so a test in the simulator can write to it.
    static let iconSet = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appending(path: "Tomi/Resources/Assets.xcassets/AppIcon.appiconset")

    /// The file of this appearance, as named in the icon set's `Contents.json`.
    var shippedFile: URL {
        Self.iconSet.appending(path: fileName)
    }

    private var fileName: String {
        switch self {
        case .light: "AppIcon.png"
        case .dark: "AppIcon-Dark.png"
        case .tinted: "AppIcon-Tinted.png"
        }
    }
}
