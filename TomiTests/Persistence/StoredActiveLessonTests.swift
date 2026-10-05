import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The bookmark of the lesson in progress in the SwiftData store, including a second one from another device.
@MainActor
@Suite struct StoredActiveLessonTests {
    let fixture: StoreFixture

    init() throws {
        fixture = try StoreFixture()
    }

    @Test func savingTwiceKeepsOneRecord() throws {
        try fixture.store.saveActiveLesson(.fixture("an-omelette", onStep: 1), at: .october(5))
        try fixture.store.saveActiveLesson(.fixture("an-omelette", onStep: 2), at: .october(5))
        #expect(try fixture.count(of: ActiveLessonRecord.self) == 1)
    }

    @Test func ofTwoBookmarksTheOneChangedLastIsRead() throws {
        try fixture.insertBookmark(.fixture("a-roast", onStep: 4), changedOnOctober: 6)
        try fixture.insertBookmark(.fixture("an-omelette", onStep: 1), changedOnOctober: 5)
        #expect(try fixture.store.activeLesson() == .fixture("a-roast", onStep: 4))
    }

    @Test func savingLeavesOnlyTheNewBookmark() throws {
        try fixture.insertBookmark(.fixture("a-roast", onStep: 4), changedOnOctober: 6)
        try fixture.insertBookmark(.fixture("an-omelette", onStep: 1), changedOnOctober: 5)
        try fixture.store.saveActiveLesson(.fixture("a-soup", onStep: 0), at: .october(7))
        #expect(try fixture.count(of: ActiveLessonRecord.self) == 1)
        #expect(try fixture.store.activeLesson() == .fixture("a-soup", onStep: 0))
    }

    @Test func clearingRemovesEveryBookmark() throws {
        try fixture.insertBookmark(.fixture("a-roast", onStep: 4), changedOnOctober: 6)
        try fixture.insertBookmark(.fixture("an-omelette", onStep: 1), changedOnOctober: 5)
        try fixture.store.clearActiveLesson()
        #expect(try fixture.count(of: ActiveLessonRecord.self) == 0)
    }

    @Test func aRecordThatDoesNotSayWhichLessonIsNoBookmark() throws {
        fixture.container.mainContext.insert(ActiveLessonRecord())
        #expect(try fixture.store.activeLesson() == nil)
    }
}
