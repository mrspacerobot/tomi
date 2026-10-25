/// The graph release channel that authored the teaching payload.
public enum TeachingChannel: String, Hashable, Decodable, Sendable {
    case draft, production
}
