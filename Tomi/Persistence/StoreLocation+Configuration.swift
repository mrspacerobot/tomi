import Foundation
import SwiftData

extension StoreLocation {
    private static let phoneFileName = "Tomi.store"
    private static let uiTestFileName = "TomiUITests.store"

    /// How SwiftData opens a store at this location.
    /// iCloud sync is switched off here on purpose. It is switched on, for the cook's own store only,
    /// when sync ships (phase 9 of the plan); the records are already laid out for it.
    func configuration(for schema: Schema) throws -> ModelConfiguration {
        guard let file = try file() else {
            return ModelConfiguration(schema: schema, isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        }
        return ModelConfiguration(schema: schema, url: file, cloudKitDatabase: .none)
    }

    /// The file the store is kept in, or nil for a store in memory.
    private func file() throws -> URL? {
        switch self {
        case .phone: Self.fileInApplicationSupport(named: Self.phoneFileName)
        case .uiTestFile: Self.fileInApplicationSupport(named: Self.uiTestFileName)
        case .memory: nil
        case .unavailable: throw ProgressStoreError.unavailable
        case .file(let url): url
        }
    }

    private static func fileInApplicationSupport(named name: String) -> URL {
        URL.applicationSupportDirectory.appending(path: name)
    }
}
