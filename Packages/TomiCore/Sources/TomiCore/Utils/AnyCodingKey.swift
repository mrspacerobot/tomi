/// A coding key for any name, to look at every key an object has, not only the ones a type knows.
struct AnyCodingKey: CodingKey {
    let stringValue: String
    var intValue: Int? { nil }

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        nil
    }
}
