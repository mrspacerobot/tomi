import Foundation

extension LibraryOptions {
    /// The avoid items of one group, in the order the server sends them.
    public func avoidItems(of kind: AvoidKind) -> [AvoidOption] {
        avoidItems.filter { $0.kind == kind }
    }

    /// The saved ids this list cannot name, for example saved by a newer server. They still count as avoided.
    public func unlistedAvoidIDs(in saved: Set<OptionID>) -> [OptionID] {
        let listed = Set(avoidItems.map(\.id))
        return saved.subtracting(listed).sorted()
    }

    /// Finds names in the server's avoid list. It never turns an unrecognized name into a restriction ID.
    public func avoidMatches(for text: String) -> [AvoidOption] {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return [] }
        return avoidItems.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

}
