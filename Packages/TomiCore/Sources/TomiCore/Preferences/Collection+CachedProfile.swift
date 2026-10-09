/// One profile out of every stored copy. There should be one record, but nothing stops two devices from
/// each saving their own before iCloud brings them together.
extension Collection where Element == SavedProfile {
    /// The copy changed last, or nil when nothing is saved or two different copies share the newest stamp.
    /// The answer never depends on the order of the records. It is only a cache: the server's profile wins.
    public var cachedProfile: CookProfile? {
        guard let newest else {
            return nil
        }
        return newest.profile
    }
}
