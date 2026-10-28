import Foundation

/// The server's answer for the cook entry that was sent.
public struct CookEntryResult: Hashable, Decodable, Sendable {
    /// Missing only when the server could not read the entry's id. It is the one entry that was sent.
    public let id: UUID?
    public let status: CookEntryStatus
    /// Why a rejected entry was refused. Empty for every other status.
    public let problems: [CookEntryProblem]

    enum CodingKeys: String, CodingKey {
        case id, status, problems
    }

    public init(id: UUID?, status: CookEntryStatus, problems: [CookEntryProblem] = []) {
        self.id = id
        self.status = status
        self.problems = problems
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id)
        status = try values.decode(CookEntryStatus.self, forKey: .status)
        problems = try values.decodeIfPresent([CookEntryProblem].self, forKey: .problems) ?? []
    }
}
