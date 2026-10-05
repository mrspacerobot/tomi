/// The answer to "anything to avoid?" while the cook is still giving it: the items they ticked, or
/// "None of these", which is an answer of its own so that having nothing to avoid is always a deliberate choice.
/// The two never hold together: ticking an item clears "None of these", and "None of these" clears every tick.
public struct AvoidAnswer: Hashable, Sendable {
    public private(set) var avoided: Set<AvoidItemID>
    public private(set) var isNoneTicked = false

    public init() {
        avoided = []
    }

    /// The answer as saved. Saved preferences cannot tell "none" from "not asked yet",
    /// so an empty list is an open question. Items this version does not list are kept, never dropped.
    public init(saved: Set<AvoidItemID>) {
        avoided = saved
    }

    public var isAnswered: Bool {
        isNoneTicked || !avoided.isEmpty
    }

    public func isTicked(_ item: AvoidItemID) -> Bool {
        avoided.contains(item)
    }

    public mutating func tap(_ item: AvoidItemID) {
        isNoneTicked = false
        if avoided.contains(item) {
            avoided.remove(item)
        } else {
            avoided.insert(item)
        }
    }

    public mutating func tapNone() {
        avoided = []
        isNoneTicked.toggle()
    }
}
