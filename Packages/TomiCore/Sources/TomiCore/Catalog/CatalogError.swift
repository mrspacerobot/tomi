/// Why a catalog file could not be used. The app keeps the copy it already has when a download fails this way.
public enum CatalogError: Error, Equatable {
    /// Written for a newer or older app. Nothing past the version number was read.
    case unsupportedSchemaVersion(Int)
    case invalid([CatalogIssue])
}
