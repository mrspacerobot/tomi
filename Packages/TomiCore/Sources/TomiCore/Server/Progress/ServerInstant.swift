import Foundation

/// A moment as Tomi's server writes and reads it: an RFC 3339 instant in UTC, such as `2026-10-26T18:43:02Z`.
/// It is written to the second. Text that is not such an instant is refused, never guessed.
public struct ServerInstant: Hashable, Codable, Sendable {
    /// The format styles are in UTC unless told otherwise, so no zone of the phone is ever read.
    private static let styles = [Date.ISO8601FormatStyle(), Date.ISO8601FormatStyle(includingFractionalSeconds: true)]

    public let date: Date

    public init(_ date: Date) {
        self.date = date
    }

    public init(from decoder: any Decoder) throws {
        let text = try decoder.singleValueContainer().decode(String.self)
        for style in Self.styles {
            if let date = try? style.parse(text) {
                self.date = date
                return
            }
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Not an instant."))
    }

    public func encode(to encoder: any Encoder) throws {
        var value = encoder.singleValueContainer()
        try value.encode(date.formatted(Date.ISO8601FormatStyle()))
    }
}
