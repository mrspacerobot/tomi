/// The graph's ids are its type, a slash and the name. The fake builds them from the lesson library's own ids,
/// so no Swift file names one.
nonisolated enum FakeGraphID {
    static func recipe(_ id: String) -> String {
        "recipe/" + id
    }

    static func ingredient(_ id: String) -> String {
        "ingredient/" + id
    }

    static func equipment(_ id: String) -> String {
        "equipment/" + id
    }
}
