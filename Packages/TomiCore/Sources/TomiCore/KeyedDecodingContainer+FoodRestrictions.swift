/// Reading saved diet and avoid answers so that whatever goes wrong, the cook is never offered more than they allowed.
/// Every saved id is kept, even one unknown here, and a field that is there but cannot be read becomes `unreadable`.
extension KeyedDecodingContainer {
    /// A saved restriction: nil when the field is missing or null, `unreadable` when it is there but not a string.
    func restriction<ID: SavedFoodRestriction>(_ type: ID.Type, forKey key: Key) -> ID? {
        if isMissingOrNull(key) {
            return nil
        }
        guard let savedValue = value(String.self, forKey: key) else {
            return ID.unreadable
        }
        return ID(rawValue: savedValue)
    }

    /// Saved restrictions: empty when the field is missing or null, `unreadable` when it is not a list of strings.
    func restrictions<ID: SavedFoodRestriction>(_ type: ID.Type, forKey key: Key) -> Set<ID> {
        if isMissingOrNull(key) {
            return []
        }
        guard let savedValues = value([String].self, forKey: key) else {
            return [ID.unreadable]
        }
        return Set(savedValues.map { ID(rawValue: $0) })
    }

    private func isMissingOrNull(_ key: Key) -> Bool {
        guard contains(key) else {
            return true
        }
        let isNull = try? decodeNil(forKey: key)
        return isNull == true
    }
}
