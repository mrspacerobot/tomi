import Foundation

/// The backend's own examples of the progress routes, copied verbatim from tomi-backend's `docs/progress.md`
/// (the snapshot) and `docs/examples/cook-entries.json` (a batch and its answer).
enum ProgressJSON {
    static var snapshot: String {
        fixture(named: "progress")
    }

    static var cookEntries: String {
        fixture(named: "cook-entries")
    }

    /// The snapshot with one piece of its text changed. A test checks that the change happened,
    /// so it can never pass because the text it meant to break was not there.
    static func snapshot(replacing old: String, with new: String) -> String {
        snapshot.replacingOccurrences(of: old, with: new)
    }

    /// The snapshot with the value at this path of keys and positions set, or the key removed when `value` is nil.
    /// The fixture is edited as JSON, so no test depends on how the example is laid out.
    static func snapshot(setting path: [JSONStep], to value: Any?) -> String {
        guard let whole = try? JSONSerialization.jsonObject(with: Data(snapshot.utf8)) else {
            return "{}"
        }
        let edited = JSONEdit(path: path, value: value).applied(to: whole)
        guard let data = try? JSONSerialization.data(withJSONObject: edited) else {
            return "{}"
        }
        return String(bytes: data, encoding: .utf8) ?? "{}"
    }

    static func snapshot(removing path: [JSONStep]) -> String {
        snapshot(setting: path, to: nil)
    }

    /// Any JSON text with the value at this path removed.
    static func removing(_ path: [JSONStep], from text: String) -> String {
        guard let whole = try? JSONSerialization.jsonObject(with: Data(text.utf8)) else {
            return "{}"
        }
        let edited = JSONEdit(path: path, value: nil).applied(to: whole)
        guard let data = try? JSONSerialization.data(withJSONObject: edited) else {
            return "{}"
        }
        return String(bytes: data, encoding: .utf8) ?? "{}"
    }

    /// One part of a fixture as a JSON object, such as the request of the cook-entries example.
    static func object(_ key: String, of text: String) throws -> NSDictionary {
        let whole = try object(of: Data(text.utf8))
        guard let part = whole[key] as? NSDictionary else {
            return [:]
        }
        return part
    }

    /// What an encoded value says, as a JSON object, so two texts compare by meaning and not by key order.
    static func object(of data: Data) throws -> NSDictionary {
        guard let object = try JSONSerialization.jsonObject(with: data) as? NSDictionary else {
            return [:]
        }
        return object
    }

    private static func fixture(named name: String) -> String {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures") else {
            return "{}"
        }
        return (try? String(contentsOf: url, encoding: .utf8)) ?? "{}"
    }
}
