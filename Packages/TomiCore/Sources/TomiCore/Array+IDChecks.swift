/// Checks on hand-typed ids, shared by the validators of the skill catalog and the ingredient table.
extension Array where Element: Hashable & Comparable {
    /// Each value that appears more than once, sorted.
    var duplicates: [Element] {
        let groups = Dictionary(grouping: self) { $0 }
        let repeated = groups.filter { $0.value.count > 1 }
        return repeated.keys.sorted()
    }
}

extension Array where Element == String {
    /// Where the empty or all-space values sit, counting from 0. An empty id is an easy slip that still decodes.
    var blankPositions: [Int] {
        indices.filter { self[$0].allSatisfy(\.isWhitespace) }
    }
}
