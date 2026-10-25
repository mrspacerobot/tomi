import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The phone's copy of the server's profile in the SwiftData store, including what iCloud can do to it:
/// nothing is unique, so a second profile record can arrive from another device.
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

    @Test func ofTwoRecordsTheNewerCopyIsRead() throws {
        try fixture.insertProfile(.fixture(diet: "vegan", avoid: ["nuts"]), changedOnOctober: 5)
        try fixture.insertProfile(.fixture(diet: nil, avoid: ["pork"]), changedOnOctober: 6)
        #expect(try fixture.store.profile() == .fixture(diet: nil, avoid: ["pork"]))
    }

    @Test func savingLeavesOneRecordHoldingExactlyTheNewCopy() throws {
        try fixture.insertProfile(.fixture(diet: "vegan", avoid: ["nuts"]), changedOnOctober: 5)
        try fixture.insertProfile(.fixture(diet: nil, avoid: ["pork"]), changedOnOctober: 6)
        try fixture.store.saveProfile(.fixture(diet: "vegetarian"), at: .october(7))
        #expect(try fixture.count(of: ProfileRecord.self) == 1)
        #expect(try fixture.store.profile() == .fixture(diet: "vegetarian"))
    }

    /// The copy keeps whatever id the server sent, known to this build or not.
    @Test func anIdTheAppHasNeverSeenIsKeptAsItIs() throws {
        try fixture.store.saveProfile(.fixture(diet: "a-diet-from-a-newer-server"), at: .october(5))
        #expect(try fixture.store.profile().diet == "a-diet-from-a-newer-server")
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
