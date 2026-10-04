import Foundation

/// The library folder the app ships (`Tomi/Resources/Library`), found from the repository root,
/// so that moving a test file never breaks a path.
enum ShippedLibrary {
    static let folder = Repository.file("Tomi/Resources/Library")
}
