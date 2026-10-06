/// Why an equipment list could not be used.
public enum EquipmentListError: Error, Equatable {
    /// Written for a newer or older app. Nothing past the version number was read.
    case unsupportedSchemaVersion(Int)
    case invalid([EquipmentIssue])
}
