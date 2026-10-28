extension CookEntryResult {
    /// Whether this result, given in the place of `cook`, is the answer for it. A result without an id is the
    /// answer for an entry the server could not read, so one bad entry can never block the outbox for good.
    func answers(_ cook: CookEntryPayload) -> Bool {
        guard let id else {
            return true
        }
        return id == cook.id
    }
}
