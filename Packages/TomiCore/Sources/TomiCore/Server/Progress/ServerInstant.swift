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
            if let date = try? style.parse(text), Self.isExactly(text, the: date) {
                self.date = date
                return
            }
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Not an instant."))
    }

    /// The parser reads past the end of the text and moves an impossible day, such as 30 February, to the next
    /// month. The text is an instant only when it is nothing but the date and time it names, to the second and
    /// in UTC, so the instant must write itself back as the same seconds.
    private static func isExactly(_ text: String, the date: Date) -> Bool {
        guard let shape = text.wholeMatch(of: /(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})(\.\d+)?Z/) else {
            return false
        }
        return date.formatted(Date.ISO8601FormatStyle()) == shape.1 + "Z"
    }

    public func encode(to encoder: any Encoder) throws {
        var value = encoder.singleValueContainer()
        try value.encode(date.formatted(Date.ISO8601FormatStyle()))
    }
}
