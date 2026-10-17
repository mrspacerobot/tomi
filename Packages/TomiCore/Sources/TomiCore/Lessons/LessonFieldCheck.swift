/// Reads only the names of the fields of a lesson file and rejects the file if it has one a lesson does not have.
/// A field such as `diets` or `allergens` would otherwise be ignored without a word, and someone would
/// believe a tag they typed is used. Tags are computed by the server, never written.
struct LessonFieldCheck: Decodable {
    init(from decoder: any Decoder) throws {
        let fields = try decoder.container(keyedBy: FieldName.self)
        for field in fields.allKeys where Lesson.CodingKeys(stringValue: field.stringValue) == nil {
            throw DecodingError.dataCorruptedError(
                forKey: field,
                in: fields,
                debugDescription: "A lesson has no field with this name."
            )
        }
    }
}
