import Foundation

/// The library folder the app ships (`Tomi/Resources/Library`), found from the repository root,
/// so that moving a test file never breaks a path.
enum ShippedLibrary {
    static let folder = repositoryRoot().appending(path: "Tomi/Resources/Library")

    /// Walks up from this file to the `Packages` folder. The repository root is the folder above it.
    private static func repositoryRoot() -> URL {
        var folder = URL(filePath: #filePath).deletingLastPathComponent()
        while folder.lastPathComponent != "Packages" && folder.path != "/" {
            folder = folder.deletingLastPathComponent()
        }
        return folder.deletingLastPathComponent()
    }
}
