import Foundation
import Testing

@testable import TomiCore

/// Checks the catalog the app ships, so a content mistake fails here without needing the simulator.
@Suite struct ShippedCatalogTests {
    static let catalogURL = URL(filePath: #filePath)
        .deletingLastPathComponent()
        .appending(path: "../../../../Tomi/Resources/Library/catalog.json")
        .standardized

    @Test func theShippedCatalogIsValid() throws {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: Self.catalogURL))
        #expect(!catalog.skills.isEmpty)
    }

    @Test func everyShippedSkillHasADistinctName() throws {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: Self.catalogURL))
        let names = catalog.skills.map { $0.name.resolved(preferredLanguages: ["en"]) }
        #expect(Set(names).count == names.count)
    }

    @Test func theShippedMenuStartsWithSomethingToCookAndCanBeFullyMastered() throws {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: Self.catalogURL))
        let log = ProgressTestLog(catalog: catalog)
        #expect(log.progress([]).focus(preferring: nil) == catalog.skills.first?.id)
        let finished = log.progress(log.cooksCompletingEverything())
        let unfinished = finished.skills.filter { !$0.isMastered }
        #expect(unfinished.isEmpty)
        #expect(finished.focus(preferring: nil) == nil)
    }
}
