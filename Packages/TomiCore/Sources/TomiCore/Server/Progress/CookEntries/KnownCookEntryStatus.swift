/// The server's words for the statuses this app knows. Permanent once released.
enum KnownCookEntryStatus: String {
    case accepted, duplicate, conflict, rejected

    var status: CookEntryStatus {
        switch self {
        case .accepted: .accepted
        case .duplicate: .duplicate
        case .conflict: .conflict
        case .rejected: .rejected
        }
    }
}
