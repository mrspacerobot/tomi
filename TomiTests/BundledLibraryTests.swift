import Foundation
import Testing
import TomiCore

@testable import Tomi

@Suite struct BundledLibraryTests {
    @Test func theCatalogShipsInTheAppAndIsValid() throws {
        let catalog = try SkillCatalog.decode(from: BundledLibrary.catalogData())
        #expect(BundledLibrary.catalog() == catalog)
    }

    @Test func everySkillReadsInTheCooksLanguage() throws {
        let catalog = try #require(BundledLibrary.catalog())
        for skill in catalog.skills {
            #expect(!skill.name.resolved(preferredLanguages: Locale.preferredLanguages).isEmpty)
        }
    }

    @Test func aMissingCatalogGivesNoCatalog() throws {
        #expect(BundledLibrary.catalog(in: try Bundle.fixture(catalog: nil)) == nil)
    }

    @Test(arguments: ["", "not json", #"{"schemaVersion": 99}"#, #"{"schemaVersion": 1, "courses": []}"#])
    func anUnreadableCatalogGivesNoCatalog(contents: String) throws {
        #expect(BundledLibrary.catalog(in: try Bundle.fixture(catalog: Data(contents.utf8))) == nil)
    }

    @Test func aCatalogThatFailsValidationGivesNoCatalog() throws {
        let empty = #"{"schemaVersion": 1, "libraryVersion": 1, "courses": [], "skills": []}"#
        let bundle = try Bundle.fixture(catalog: Data(empty.utf8))
        #expect(BundledLibrary.catalog(in: bundle) == nil)
    }

    @Test func aValidCatalogInAnyBundleIsRead() throws {
        let bundle = try Bundle.fixture(catalog: BundledLibrary.catalogData())
        #expect(BundledLibrary.catalog(in: bundle) == BundledLibrary.catalog())
    }
}
