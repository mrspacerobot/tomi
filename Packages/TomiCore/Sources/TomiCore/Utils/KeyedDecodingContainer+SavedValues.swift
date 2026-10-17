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
}
