import Foundation

/// The files of the repository, found from this file's own place, for tests that read sources and documents.
enum Repository {
    static let root = findRoot()

    static func file(_ path: String) -> URL {
        root.appending(path: path)
    }

    static func text(_ path: String) throws -> String {
        try String(contentsOf: file(path), encoding: .utf8)
    }

    /// Every Swift file under a folder of the repository, in any subfolder, sorted by path.
    static func swiftFiles(under folder: String) throws -> [SourceFile] {
        var files: [SourceFile] = []
        for path in try swiftPaths(under: folder) {
            files.append(SourceFile(path: path, text: try text(path)))
        }
        return files
    }

    /// The names of the Swift files that sit directly in a folder, not in its subfolders.
    static func swiftFileNames(directlyIn folder: String) throws -> [String] {
        try namesOfEntries(in: folder).filter { $0.hasSuffix(".swift") }
    }

    /// The names of the folders that sit directly in a folder.
    static func folderNames(in folder: String) throws -> [String] {
        try namesOfEntries(in: folder).filter { !$0.contains(".") }
    }

    private static func namesOfEntries(in folder: String) throws -> [String] {
        try FileManager.default.contentsOfDirectory(atPath: file(folder).path()).sorted()
    }

    /// The paths of every file under a folder of the repository whose name ends so, in any subfolder, sorted.
    static func paths(under folder: String, ending suffix: String) throws -> [String] {
        let all = try FileManager.default.subpathsOfDirectory(atPath: file(folder).path())
        let matching = all.filter { $0.hasSuffix(suffix) }
        return matching.sorted().map { folder + "/" + $0 }
    }

    private static func swiftPaths(under folder: String) throws -> [String] {
        try paths(under: folder, ending: ".swift")
    }

    /// Walks up from this file to the `Packages` folder. The repository root is the folder above it.
    private static func findRoot() -> URL {
        var folder = URL(filePath: #filePath).deletingLastPathComponent()
        while folder.lastPathComponent != "Packages" && folder.path != "/" {
            folder = folder.deletingLastPathComponent()
        }
        return folder.deletingLastPathComponent()
    }
}
