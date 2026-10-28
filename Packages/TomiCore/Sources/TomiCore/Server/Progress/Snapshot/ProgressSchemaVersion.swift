/// The layout of a progress snapshot. It is read before any other field, and a layout this app does not know
/// refuses the whole snapshot. A field the server adds does not change it.
public struct ProgressSchemaVersion: Hashable, Decodable, Sendable {
    public static let supported = 1

    public let number: Int

    public init(from decoder: any Decoder) throws {
        let number = try decoder.singleValueContainer().decode(Int.self)
        guard number == Self.supported else {
            throw ProgressSnapshotError.unsupportedSchemaVersion(number)
        }
        self.number = number
    }
}
