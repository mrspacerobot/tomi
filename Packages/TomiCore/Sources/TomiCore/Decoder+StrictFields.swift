/// Strict reading for the parts of the library where a skipped field could look like a safe one.
extension Decoder {
    /// Throws when the object holds a field that `Fields` does not name.
    /// A field such as `allergens`, or a misspelt `contain`, would otherwise be ignored and its facts lost silently.
    func rejectFields<Fields: CodingKey>(notIn known: Fields.Type) throws {
        let written = try container(keyedBy: FieldName.self)
        for field in written.allKeys where Fields(stringValue: field.stringValue) == nil {
            throw DecodingError.dataCorruptedError(
                forKey: field,
                in: written,
                debugDescription: "There is no field with this name here."
            )
        }
    }
}
