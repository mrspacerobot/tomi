/// Any field name found in a file, so a decoder can see the fields it was not written to read.
struct FieldName: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}
