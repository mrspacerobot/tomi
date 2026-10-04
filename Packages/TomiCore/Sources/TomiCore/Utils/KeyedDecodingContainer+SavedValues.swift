/// Reading saved data that an older or a newer version of the app may have written.
/// Nothing here throws: whatever cannot be read comes back as nil, and the caller keeps its default.
extension KeyedDecodingContainer {
    /// The value under `key`, or nil when the field is missing or has another shape.
    func value<Value: Decodable>(_ type: Value.Type, forKey key: Key) -> Value? {
        try? decodeIfPresent(type, forKey: key)
    }

    /// One saved answer from a closed list, or nil when it is missing or a newer app wrote a value unknown here.
    func knownValue<Value: RawRepresentable>(_ type: Value.Type, forKey key: Key) -> Value?
    where Value.RawValue == String {
        guard let savedValue = value(String.self, forKey: key) else {
            return nil
        }
        return Value(rawValue: savedValue)
    }

    /// A saved list of answers, without the values a newer app wrote that are unknown here.
    /// Nil when the field is missing, so an empty list stays an answer of its own.
    func knownValues<Value: RawRepresentable & Hashable>(_ type: Value.Type, forKey key: Key) -> Set<Value>?
    where Value.RawValue == String {
        guard let savedValues = value([String].self, forKey: key) else {
            return nil
        }
        var known: Set<Value> = []
        for savedValue in savedValues {
            if let value = Value(rawValue: savedValue) {
                known.insert(value)
            }
        }
        return known
    }
}
