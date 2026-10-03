import Foundation
import Testing

extension Bundle {
    /// A throwaway bundle holding the given catalog file, or none.
    static func fixture(catalog: Data?) throws -> Bundle {
        try fixture(file: "catalog.json", contents: catalog)
    }

    /// A throwaway bundle holding the given ingredient table file, or none.
    static func fixture(ingredients: Data?) throws -> Bundle {
        try fixture(file: "ingredients.json", contents: ingredients)
    }

    /// Each call gets a fresh folder, because Foundation caches bundles by path.
    private static func fixture(file name: String, contents: Data?) throws -> Bundle {
        let folder = FileManager.default.temporaryDirectory.appending(
            path: UUID().uuidString,
            directoryHint: .isDirectory
        )
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        if let contents {
            try contents.write(to: folder.appending(path: name))
        }
        return try #require(Bundle(url: folder))
    }
}
