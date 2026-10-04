import Foundation

extension IngredientTable {
    /// Reads a table file and accepts it only if this build understands its layout and it passes validation.
    public static func decode(from data: Data) throws -> IngredientTable {
        let version = try JSONDecoder().decode(CatalogSchemaHeader.self, from: data).schemaVersion
        guard version == supportedSchemaVersion else {
            throw IngredientTableError.unsupportedSchemaVersion(version)
        }
        let table = try JSONDecoder().decode(IngredientTable.self, from: data)
        guard table.issues.isEmpty else {
            throw IngredientTableError.invalid(table.issues)
        }
        return table
    }
}
