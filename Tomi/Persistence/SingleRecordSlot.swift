import Foundation
import SwiftData
import TomiCore

/// The place in the store for a kind of record there should be one of.
/// Nothing in the store is unique, so iCloud can deliver a second one from another device.
/// Reading hands over every record and lets TomiCore decide. Writing leaves exactly one behind.
struct SingleRecordSlot<Record: SingleRecord> {
    let context: ModelContext

    func records() throws -> [Record] {
        try context.fetch(FetchDescriptor<Record>())
    }

    /// The record to write into, stamped with the moment: the newest one, or a new one when there is none.
    /// Every other record is deleted, so what is written now becomes the one answer.
    func recordToWrite(at moment: Date) throws -> Record {
        let records = try records()
        let record = newest(of: records) ?? inserted()
        for other in records where other !== record {
            context.delete(other)
        }
        record.updatedAt = moment
        return record
    }

    func clear() throws {
        for record in try records() {
            context.delete(record)
        }
    }

    private func newest(of records: [Record]) -> Record? {
        records.max { older, newer in stamp(of: newer).isNewer(than: stamp(of: older)) }
    }

    private func stamp(of record: Record) -> RecordStamp {
        RecordStamp(stableID: record.stableID, updatedAt: record.updatedAt)
    }

    private func inserted() -> Record {
        let record = Record()
        record.stableID = UUID()
        context.insert(record)
        return record
    }
}
