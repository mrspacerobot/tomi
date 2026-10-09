import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The lessons the app really ships, read through the bundle as the app reads them.
@Suite struct BundledLessonLibraryTests {
    @Test func theExampleLessonsShipInTheApp() {
        let ids = BundledLessonLibrary().lessons.map(\.id)
        #expect(ids == [LibraryFixture.searedChicken, LibraryFixture.omelette])
    }

    /// Strict decoding throws with the reason, so an invalid shipped lesson fails here by name.
    @Test func everyShippedLessonFileIsValidAndNamedByItsID() throws {
        let catalog = try #require(BundledLibrary.catalog())
        let files = BundledLibrary.lessonFiles()
        #expect(files.count == BundledLessonLibrary().lessons.count)
        for file in files {
            let lesson = try Lesson.decode(from: Data(contentsOf: file), catalog: catalog)
            #expect(file.lastPathComponent == lesson.fileName)
        }
    }

    @Test func theCatalogIsNotTakenForALesson() {
        let names = BundledLibrary.lessonFiles().map(\.lastPathComponent)
        #expect(!names.contains(LibraryFixture.catalogFile))
        #expect(names.allSatisfy { $0.hasSuffix(".lesson.json") })
    }

    /// The food lists moved to the server: the app ships none of them.
    @Test func theAppShipsNoIngredientTableAndNoEquipmentList() {
        #expect(Bundle.main.url(forResource: "ingredients", withExtension: "json") == nil)
        #expect(Bundle.main.url(forResource: "equipment", withExtension: "json") == nil)
    }

    @Test func theLibraryServesTheSameCatalogAsTheBundle() {
        #expect(BundledLessonLibrary().catalog == BundledLibrary.catalog())
    }

    @Test func everyShippedLessonReadsInTheCooksLanguage() {
        for lesson in BundledLessonLibrary().lessons {
            #expect(!lesson.title.resolved(preferredLanguages: Locale.preferredLanguages).isEmpty)
        }
    }
}
