import Foundation
import OSLog
import TomiCore

/// The lesson library that ships inside the app. A signed download replaces it once the hosted library is live.
enum BundledLibrary {
    nonisolated private static let logger = Logger(category: .library)

    /// The skill catalog, or nil if the bundled file is missing or invalid, which the app's tests rule out.
    /// Tests pass their own bundle to reach the failure path.
    nonisolated static func catalog(in bundle: Bundle = .main) -> SkillCatalog? {
        do {
            return try SkillCatalog.decode(from: catalogData(in: bundle))
        } catch {
            logger.error("The bundled skill catalog could not be read: \(String(describing: error), privacy: .public)")
            return nil
        }
    }

    /// The ingredient table, or nil if the bundled file is missing or invalid, which the app's tests rule out.
    /// Without a table no ingredient can be checked, so the caller must not serve anything.
    nonisolated static func ingredientTable(in bundle: Bundle = .main) -> IngredientTable? {
        do {
            return try IngredientTable.decode(from: ingredientTableData(in: bundle))
        } catch {
            logger.error(
                "The bundled ingredient table could not be read: \(String(describing: error), privacy: .public)"
            )
            return nil
        }
    }

    nonisolated static func catalogData(in bundle: Bundle = .main) throws -> Data {
        try data(ofFile: "catalog", in: bundle)
    }

    nonisolated static func ingredientTableData(in bundle: Bundle = .main) throws -> Data {
        try data(ofFile: "ingredients", in: bundle)
    }

    nonisolated private static func data(ofFile name: String, in bundle: Bundle) throws -> Data {
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try Data(contentsOf: url)
    }
}
