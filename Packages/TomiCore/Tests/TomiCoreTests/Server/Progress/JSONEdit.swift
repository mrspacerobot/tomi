import Foundation

/// Sets or removes one value inside a JSON value, leaving everything else as it was.
struct JSONEdit {
    let path: [JSONStep]
    /// Nil removes the key at the end of the path.
    let value: Any?

    func applied(to json: Any) -> Any {
        edit(json, remaining: path[...])
    }

    private func edit(_ json: Any, remaining: ArraySlice<JSONStep>) -> Any {
        guard let step = remaining.first else {
            return json
        }
        let rest = remaining.dropFirst()
        switch step {
        case .key(let key): return editObject(json, key: key, rest: rest)
        case .position(let index): return editArray(json, index: index, rest: rest)
        }
    }

    private func editObject(_ json: Any, key: String, rest: ArraySlice<JSONStep>) -> Any {
        guard var object = json as? [String: Any] else {
            return json
        }
        if rest.isEmpty {
            object[key] = value
        } else if let inner = object[key] {
            object[key] = edit(inner, remaining: rest)
        }
        return object
    }

    private func editArray(_ json: Any, index: Int, rest: ArraySlice<JSONStep>) -> Any {
        guard var array = json as? [Any], array.indices.contains(index) else {
            return json
        }
        array[index] = edit(array[index], remaining: rest)
        return array
    }
}
