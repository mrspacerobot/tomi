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
        let table = try #require(BundledLibrary.ingredientTable())
        let files = BundledLibrary.lessonFiles()
        #expect(files.count == BundledLessonLibrary().lessons.count)
        for file in files {
            let lesson = try Lesson.decode(from: Data(contentsOf: file), catalog: catalog, table: table)
            #expect(file.lastPathComponent == lesson.fileName)
        }
    }

    @Test func theCatalogAndTheIngredientTableAreNotTakenForLessons() {
        let names = BundledLibrary.lessonFiles().map(\.lastPathComponent)
        #expect(!names.contains("catalog.json"))
        #expect(!names.contains("ingredients.json"))
        #expect(names.allSatisfy { $0.hasSuffix(".lesson.json") })
    }

    @Test func theLibraryServesTheSameCatalogAndTableAsTheBundle() {
        let library = BundledLessonLibrary()
        #expect(library.catalog == BundledLibrary.catalog())
        #expect(library.ingredientTable == BundledLibrary.ingredientTable())
    }

    @Test func everyShippedLessonUsesOnlyIngredientsOfTheShippedTable() throws {
        let library = BundledLessonLibrary()
        let table = try #require(library.ingredientTable)
        for lesson in library.lessons {
            #expect(throws: Never.self) {
                try lesson.tags(in: table)
            }
        }
    }

    @Test func theOmeletteIsVegetarian() throws {
        let table = try #require(BundledLibrary.ingredientTable())
        let omelette = try LibraryFixture.shippedOmelette()
        var vegetarian = CookPreferences()
        vegetarian.diet = .vegetarian
        #expect(try omelette.isAllowed(by: vegetarian, in: table))
        #expect(try omelette.tags(in: table).avoidItems == [.eggs, .dairy])
    }

    @Test func theSearedChickenIsNotVegetarian() throws {
        let library = BundledLessonLibrary()
        let table = try #require(library.ingredientTable)
        let chicken = try #require(library.lessons.first { $0.id == LibraryFixture.searedChicken })
        #expect(try chicken.tags(in: table).suitableDiets == [.everything])
        #expect(try chicken.tags(in: table).avoidItems == [.dairy, .alcohol])
    }

    @Test func everyShippedLessonReadsInTheCooksLanguage() {
        for lesson in BundledLessonLibrary().lessons {
            #expect(!lesson.title.resolved(preferredLanguages: Locale.preferredLanguages).isEmpty)
        }
    }
}
