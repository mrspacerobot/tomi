/// An id that limits what the cook may be offered, such as a diet or an avoid item.
/// When a saved restriction cannot be read, it is replaced by `unreadable` instead of being dropped,
/// so the dish filter meets an id it does not know and offers nothing until the cook answers again.
protocol SavedFoodRestriction: Hashable {
    init(rawValue: String)
}

extension SavedFoodRestriction {
    /// The blank id. Every library validator must reject blank ids, so no table can ever know this one.
    static var unreadable: Self {
        Self(rawValue: "")
    }
}
