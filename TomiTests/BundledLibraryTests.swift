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
}
