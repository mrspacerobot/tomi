import Foundation

extension SkillCatalog {
    /// Reads a catalog file and accepts it only if this build understands its layout and it passes validation.
    public static func decode(from data: Data) throws -> SkillCatalog {
        let version = try JSONDecoder().decode(CatalogSchemaHeader.self, from: data).schemaVersion
        guard version == supportedSchemaVersion else {
            throw CatalogError.unsupportedSchemaVersion(version)
        }
        let catalog = try JSONDecoder().decode(SkillCatalog.self, from: data)
        guard catalog.issues.isEmpty else {
            throw CatalogError.invalid(catalog.issues)
        }
        return catalog
    }
}
