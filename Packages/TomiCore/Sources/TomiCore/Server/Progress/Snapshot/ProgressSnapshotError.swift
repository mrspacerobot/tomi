/// Why a progress snapshot was not read.
public enum ProgressSnapshotError: Error, Hashable, Sendable {
    /// The snapshot has a layout this app does not know. Nothing else of it is read.
    case unsupportedSchemaVersion(Int)
}
