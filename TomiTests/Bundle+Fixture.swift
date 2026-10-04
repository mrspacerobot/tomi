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

    /// A throwaway bundle holding these files side by side, as the app's flat bundle does.
    /// Each call gets a fresh folder, because Foundation caches bundles by path.
    static func fixture(files: [String: Data]) throws -> Bundle {
        let folder = FileManager.default.temporaryDirectory.appending(
            path: UUID().uuidString,
            directoryHint: .isDirectory
        )
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        for (name, contents) in files {
            try contents.write(to: folder.appending(path: name))
        }
        return try #require(Bundle(url: folder))
    }

    private static func fixture(file name: String, contents: Data?) throws -> Bundle {
        guard let contents else {
            return try fixture(files: [:])
        }
        return try fixture(files: [name: contents])
    }
}
