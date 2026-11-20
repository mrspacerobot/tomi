/// Which modules a part of the code may import. The three layers of `AGENTS.md`, checked by reading the imports.
enum ImportRule {
    /// The rules package decides everything that needs no screen, so it may only use Foundation.
    static let allowedInRulesPackage: Set<String> = ["Foundation"]

    /// Frameworks that only a service may touch, and the folders of the app where those services live.
    /// Screens reach them through a protocol, so each has a fake for previews and tests.
    static let serviceFolders: [String: [String]] = [
        "FoundationModels": ["Tomi/AI/"],
        "Speech": ["Tomi/Voice/"],
        "AVFoundation": ["Tomi/Voice/", "Tomi/Camera/"],
        "SwiftData": ["Tomi/Persistence/"],
        "CloudKit": ["Tomi/Persistence/"],
        "AlarmKit": ["Tomi/Timers/"],
        "UIKit": ["Tomi/Camera/"],
        "PhotosUI": ["Tomi/Camera/"],
        "ImageIO": ["Tomi/Camera/", "Tomi/DishPhotos/"],
        "AuthenticationServices": ["Tomi/Auth/"],
        "Security": ["Tomi/Auth/"],
        "CryptoKit": ["Tomi/Auth/"],
    ]

    /// One line for every import the rules package is not allowed.
    static func violationsInRulesPackage(_ files: [SourceFile]) -> [String] {
        var violations: [String] = []
        for file in files {
            for module in file.imports where !allowedInRulesPackage.contains(module) {
                violations.append("\(file.path) imports \(module)")
            }
        }
        return violations
    }

    /// One line for every service framework imported outside its service folder.
    static func violationsInApp(_ files: [SourceFile]) -> [String] {
        var violations: [String] = []
        for file in files {
            for module in file.imports where !isAllowed(module, in: file) {
                violations.append("\(file.path) imports \(module)")
            }
        }
        return violations
    }

    private static func isAllowed(_ module: String, in file: SourceFile) -> Bool {
        guard let folders = serviceFolders[module] else {
            return true
        }
        return folders.contains { file.path.hasPrefix($0) }
    }
}
