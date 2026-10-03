import Foundation
import Testing

extension Bundle {
    /// A throwaway bundle holding the given catalog file, or none. Each call gets a fresh folder,
    /// because Foundation caches bundles by path.
    static func fixture(catalog: Data?) throws -> Bundle {
        let folder = FileManager.default.temporaryDirectory.appending(
            path: UUID().uuidString,
            directoryHint: .isDirectory
        )
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        try catalog?.write(to: folder.appending(path: "catalog.json"))
        return try #require(Bundle(url: folder))
    }
}
