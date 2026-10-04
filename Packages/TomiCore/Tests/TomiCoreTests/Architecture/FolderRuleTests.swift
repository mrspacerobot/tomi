import Testing

/// The rules package is grouped by domain folder, and its tests mirror the same folders.
@Suite struct FolderRuleTests {
    static let sources = "Packages/TomiCore/Sources/TomiCore"
    static let tests = "Packages/TomiCore/Tests/TomiCoreTests"

    @Test(arguments: [sources, tests])
    func noSwiftFileSitsInTheRootOfThePackage(folder: String) throws {
        #expect(try Repository.swiftFileNames(directlyIn: folder) == [])
    }

    @Test func theTestFoldersMirrorTheSourceFolders() throws {
        let sourceFolders = Set(try Repository.folderNames(in: Self.sources))
        let testFolders = Set(try Repository.folderNames(in: Self.tests))
        let onlyInTests = testFolders.subtracting(sourceFolders)
        #expect(!sourceFolders.isEmpty)
        #expect(onlyInTests == ["Architecture"])
    }
}
