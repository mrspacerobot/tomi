import Foundation

/// A cook log is any list of entries, in any order, possibly merged from two devices.
extension Sequence where Element == CookEntry {
    /// The entries that count as cooks: finished, and each id once however often it appears.
    /// Every rule starts here, so a merged log gives the same answers as a single one.
    public var finishedCooks: [CookEntry] {
        var seenIDs: Set<UUID> = []
        var finished: [CookEntry] = []
        for entry in self where !entry.stoppedEarly {
            let isFirstCopy = seenIDs.insert(entry.id).inserted
            if isFirstCopy {
                finished.append(entry)
            }
        }
        return finished
    }

    /// The finished cooks as the streak rules take them.
    public var completedCooks: [CompletedCook] {
        var cooks: [CompletedCook] = []
        for entry in finishedCooks {
            cooks.append(CompletedCook(date: entry.date, weeklyGoal: entry.weeklyGoal))
        }
        return cooks
    }
}
