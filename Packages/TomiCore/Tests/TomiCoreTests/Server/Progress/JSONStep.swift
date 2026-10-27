/// One step into a JSON value: the key of an object or the position in an array.
enum JSONStep: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    case key(String)
    case position(Int)

    init(stringLiteral value: String) {
        self = .key(value)
    }

    init(integerLiteral value: Int) {
        self = .position(value)
    }
}
