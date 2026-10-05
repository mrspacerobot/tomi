/// Ids as they are saved: plain strings, in a fixed order so that the same answers always save the same list.
extension Set where Element: RawRepresentable & Comparable, Element.RawValue == String {
    /// The ids of a saved list. A missing list holds no ids.
    init(savedIDs: [String]?) {
        self.init()
        guard let savedIDs else {
            return
        }
        for savedID in savedIDs {
            if let id = Element(rawValue: savedID) {
                insert(id)
            }
        }
    }

    var savedIDs: [String] {
        sorted().map(\.rawValue)
    }
}
