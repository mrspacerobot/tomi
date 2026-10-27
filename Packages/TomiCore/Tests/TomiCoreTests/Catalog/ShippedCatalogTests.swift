import Foundation
import Testing

@testable import TomiCore

/// Checks the catalog the app ships, so a content mistake fails here without needing the simulator.
@Suite struct ShippedCatalogTests {
    static let catalogURL = ShippedLibrary.folder.appending(path: "catalog.json")

    @Test func theShippedCatalogIsValid() throws {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: Self.catalogURL))
        #expect(!catalog.skills.isEmpty)
    }

    @Test func everyShippedSkillHasADistinctName() throws {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: Self.catalogURL))
        let names = catalog.skills.map { $0.name.resolved(preferredLanguages: ["en"]) }
        #expect(Set(names).count == names.count)
    }
}
