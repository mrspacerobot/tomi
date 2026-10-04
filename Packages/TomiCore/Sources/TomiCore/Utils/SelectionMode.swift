/// How many options of a list a cook may tick.
public enum SelectionMode: Hashable, Sendable {
    /// One answer: ticking another option moves the tick.
    case single
    /// Any number of answers: each option is ticked and unticked by itself.
    case multiple
}
