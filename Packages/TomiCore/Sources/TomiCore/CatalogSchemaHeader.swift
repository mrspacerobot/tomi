/// Only the version of a catalog file, so a layout from another schema is rejected before any of it is decoded.
struct CatalogSchemaHeader: Decodable {
    let schemaVersion: Int
}
