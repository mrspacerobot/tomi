import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The profile in the SwiftData store, including what iCloud can do to it: nothing is unique,
/// so a second profile record can arrive from another device.
@MainActor
@Suite struct StoredProfileTests {
    let fixture: StoreFixture

    init() throws {
        fixture = try StoreFixture()
    }

    @Test func savingTwiceKeepsOneRecordWithItsIdAndTheLaterTime() throws {
        try fixture.store.saveProfile(.fixture(diet: "vegan"), at: .october(5))
        let firstID = try record().stableID
        #expect(firstID != nil)
        try fixture.store.saveProfile(.fixture(diet: "vegetarian"), at: .october(6))
        #expect(try fixture.count(of: ProfileRecord.self) == 1)
        #expect(try record().stableID == firstID)
        #expect(try record().updatedAt == .october(6))
    }

    @Test func anOlderRecordsRestrictionsAreNotDroppedByANewerRecord() throws {
        try fixture.insertProfile(.fixture(diet: "vegan", avoid: ["nuts"]), changedOnOctober: 5)
        try fixture.insertProfile(.fixture(diet: nil, avoid: ["pork"]), changedOnOctober: 6)
        let preferences = try fixture.store.profile().preferences
        #expect(preferences.diet == "vegan")
        #expect(preferences.avoid == ["nuts", "pork"])
    }

    @Test func savingLeavesOneRecordHoldingExactlyTheCooksNewAnswer() throws {
        try fixture.insertProfile(.fixture(diet: "vegan", avoid: ["nuts"]), changedOnOctober: 5)
        try fixture.insertProfile(.fixture(diet: nil, avoid: ["pork"]), changedOnOctober: 6)
        try fixture.store.saveProfile(.fixture(diet: "vegetarian"), at: .october(7))
        #expect(try fixture.count(of: ProfileRecord.self) == 1)
        #expect(try fixture.store.profile() == .fixture(diet: "vegetarian"))
    }

    /// A diet saved by a newer app must come back as it is, so the shipped table refuses every dish.
    @Test func aDietTheShippedTableDoesNotKnowIsKeptAndRefused() throws {
        let table = try #require(BundledLibrary.ingredientTable())
        try fixture.store.saveProfile(.fixture(diet: "a-diet-from-a-newer-app"), at: .october(5))
        let preferences = try fixture.store.profile().preferences
        #expect(preferences.diet == "a-diet-from-a-newer-app")
        #expect(!table.understands(preferences))
    }

    @Test func aRecordWithNoFieldsAtAllIsReadAsTheDefaults() throws {
        fixture.container.mainContext.insert(ProfileRecord())
        #expect(try fixture.store.profile() == CookProfile())
    }

    private func record() throws -> SavedProfile {
        let context = fixture.container.mainContext
        let records = try context.fetch(.init()) as [ProfileRecord]
        return try #require(records.first).saved
    }
}
