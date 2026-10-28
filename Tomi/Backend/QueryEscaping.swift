import Foundation

/// Escapes a query for the wire. A plus must be escaped too: the server reads it as a space, which would turn a
/// zone such as `Etc/GMT+5` into one it does not know. An ampersand or an equals sign would split the query.
nonisolated enum QueryEscaping {
    static let allowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "+&="))

    static func escaped(_ item: URLQueryItem) -> URLQueryItem {
        URLQueryItem(name: escaped(item.name), value: escapedValue(item.value))
    }

    private static func escapedValue(_ value: String?) -> String? {
        guard let value else {
            return nil
        }
        return escaped(value)
    }

    /// Text that cannot be escaped, which only broken Unicode is, goes out as it is and the server refuses it.
    private static func escaped(_ text: String) -> String {
        guard let escaped = text.addingPercentEncoding(withAllowedCharacters: allowed) else {
            return text
        }
        return escaped
    }
}
