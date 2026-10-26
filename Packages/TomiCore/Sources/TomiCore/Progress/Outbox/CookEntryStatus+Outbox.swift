extension CookEntryStatus {
    /// What the status does to the cook in the outbox, or nil when the cook stays to be sent again.
    /// Accepted, duplicate and conflict all mean the server holds a copy that counts, so the cook is forgotten.
    func outboxChange(problems: [CookEntryProblem]) -> OutboxChange? {
        switch self {
        case .accepted, .duplicate, .conflict:
            return .forget
        case .rejected:
            return .refuse(code: problems.first ?? CookOutbox.unstatedProblem)
        case .unknown:
            return nil
        }
    }
}
