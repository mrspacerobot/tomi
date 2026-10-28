import Foundation
import TomiCore

extension SwiftDataProgressStore {
    func progressSnapshot() throws -> ProgressSnapshot? {
        try snapshots.records().map(\.saved).lastSnapshot
    }

    func progressSnapshot(for account: String) throws -> ProgressSnapshot? {
        try snapshots.records().map(\.saved).lastSnapshot(for: account)
    }

    func saveProgressSnapshot(_ body: Data, at moment: Date) throws {
        try saving {
            let record = try snapshots.recordToWrite(at: moment)
            record.write(body: body)
        }
    }

    func saveProgressSnapshot(_ body: Data, at moment: Date, for account: String) throws {
        try saving {
            let record = try snapshots.recordToWrite(at: moment, matching: { $0.account == account })
            record.account = account
            record.write(body: body)
        }
    }
}
