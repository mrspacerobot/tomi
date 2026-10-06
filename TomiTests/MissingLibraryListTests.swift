import Foundation
import Testing
import TomiCore

@testable import Tomi

/// A lesson is served only when every list it is checked against can be read:
/// the catalog, the ingredient table and the equipment list.
@Suite struct MissingLibraryListTests {
    @Test func withoutAnyListNoLessonIsServed() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        let bundle = try Bundle.fixture(files: [omelette.fileName: LibraryFixture.file(omelette)])
        let library = BundledLessonLibrary(bundle: bundle)
        #expect(library.lessons.isEmpty)
        #expect(library.catalog == nil)
        #expect(library.ingredientTable == nil)
        #expect(library.equipmentList == nil)
    }

    @Test(arguments: [
        LibraryFixture.catalogFile, LibraryFixture.ingredientTableFile, LibraryFixture.equipmentListFile,
    ])
    func withOneListMissingNoLessonIsServed(missing: String) throws {
        let omelette = try LibraryFixture.shippedOmelette()
        var files = try LibraryFixture.listFiles()
        files[missing] = nil
        files[omelette.fileName] = try LibraryFixture.file(omelette)
        let bundle = try Bundle.fixture(files: files)
        #expect(BundledLibrary.lists(in: bundle) == nil)
        #expect(BundledLessonLibrary(bundle: bundle).lessons.isEmpty)
    }

    @Test func withEveryListTheSameLessonIsServed() throws {
        let omelette = try LibraryFixture.shippedOmelette()
        let bundle = try LibraryFixture.bundle(lessonFiles: [omelette.fileName: LibraryFixture.file(omelette)])
        #expect(BundledLibrary.lists(in: bundle) == BundledLibrary.lists())
        #expect(BundledLessonLibrary(bundle: bundle).lessons == [omelette])
    }
}
