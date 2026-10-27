import Foundation
import TomiCore

@testable import Tomi

/// An uploader over an in-memory store, with a fixed moment, a fixed calendar and a sleeper that records its waits.
@MainActor
struct UploaderHarness {
    let store = InMemoryProgressStore()
    let sleeper: RecordingSleeper

    init(wakes: Int = 0) {
        sleeper = RecordingSleeper(wakes: wakes)
    }

    /// Monday first, in Amsterdam, as the cook's phone would be set.
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!
        calendar.firstWeekday = 2
        return calendar
    }

    func uploader(_ api: any TomiAPI) -> CookEntryUploader {
        let clock = UploaderClock(now: { .october(27) }, calendar: { Self.calendar }, sleeper: sleeper)
        return CookEntryUploader(api: api, store: store, clock: clock)
    }

    /// Saves that many finished cooks, one a day from the first of October, and gives their ids in that order.
    @discardableResult
    func saveCooks(_ count: Int) throws -> [UUID] {
        var ids: [UUID] = []
        for day in 0..<count {
            let cook = CookEntry.fixture("eggs", onOctober: 1 + day % 26)
            try store.add(cook)
            ids.append(cook.id)
        }
        return ids
    }

    /// Starts an upload, as a trigger does, and waits until it ends.
    func upload(with uploader: CookEntryUploader) async {
        uploader.upload()
        await uploader.waitUntilIdle()
    }
}
