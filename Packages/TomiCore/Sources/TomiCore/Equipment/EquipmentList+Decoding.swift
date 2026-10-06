import Foundation

extension EquipmentList {
    /// Reads a list file and accepts it only if this build understands its layout and it passes validation.
    public static func decode(from data: Data) throws -> EquipmentList {
        let version = try JSONDecoder().decode(CatalogSchemaHeader.self, from: data).schemaVersion
        guard version == supportedSchemaVersion else {
            throw EquipmentListError.unsupportedSchemaVersion(version)
        }
        let list = try JSONDecoder().decode(EquipmentList.self, from: data)
        guard list.issues.isEmpty else {
            throw EquipmentListError.invalid(list.issues)
        }
        return list
    }
}
