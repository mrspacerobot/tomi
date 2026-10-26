import Foundation

/// The server's answer for one cook entry, in the place of that entry in the batch.
public struct CookEntryResult: Hashable, Decodable, Sendable {
    /// Missing only when the server could not read the entry's id. The place in the batch says which it was.
    public let id: UUID?
    public let status: CookEntryStatus
    /// Why a rejected entry was refused. Empty for every other status.
    public let problems: [CookEntryProblem]

    enum CodingKeys: String, CodingKey {
        case id, status, problems
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id)
        status = try values.decode(CookEntryStatus.self, forKey: .status)
        problems = try values.decodeIfPresent([CookEntryProblem].self, forKey: .problems) ?? []
    }
}
