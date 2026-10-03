import Foundation
import OSLog
import TomiCore

/// The lesson library that ships inside the app. A signed download replaces it once the hosted library is live.
enum BundledLibrary {
    nonisolated private static let logger = Logger(subsystem: "com.mrspacerobot.tomi", category: "library")

    /// The skill catalog, or nil if the bundled file is missing or invalid, which the app's tests rule out.
    nonisolated static func catalog() -> SkillCatalog? {
        do {
            return try SkillCatalog.decode(from: catalogData())
        } catch {
            logger.error("The bundled skill catalog could not be read: \(String(describing: error), privacy: .public)")
            return nil
        }
    }

    nonisolated static func catalogData() throws -> Data {
        guard let url = Bundle.main.url(forResource: "catalog", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try Data(contentsOf: url)
    }
}
