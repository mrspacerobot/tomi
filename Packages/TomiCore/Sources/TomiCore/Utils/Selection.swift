/// The options ticked in a list of tick rows, and what a tap on one of them changes.
public struct Selection<Option: Hashable & Sendable>: Hashable, Sendable {
    public let mode: SelectionMode
    public private(set) var selected: Set<Option> = []

    public init(mode: SelectionMode) {
        self.mode = mode
    }

    public func isSelected(_ option: Option) -> Bool {
        selected.contains(option)
    }

    /// A single selection moves to the option and stays there on a second tap, so an answer once given is
    /// never taken away. A multiple selection ticks the option, or unticks it when it was ticked.
    public mutating func tap(_ option: Option) {
        switch mode {
        case .single:
            selected = [option]
        case .multiple:
            toggle(option)
        }
    }

    private mutating func toggle(_ option: Option) {
        if selected.contains(option) {
            selected.remove(option)
        } else {
            selected.insert(option)
        }
    }
}
