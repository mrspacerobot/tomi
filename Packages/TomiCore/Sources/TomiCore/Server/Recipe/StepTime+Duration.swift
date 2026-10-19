extension StepTime {
    /// The units of time the graph writes. A time in any other unit is not shown, never guessed.
    enum Unit: String {
        case second
        case minute
        case hour

        var seconds: Double {
            switch self {
            case .second: 1
            case .minute: 60
            case .hour: 3600
            }
        }
    }

    /// The shortest length of the step, or nil when the graph counted it in a unit this build does not know.
    public var shortestDuration: Duration? {
        duration(of: shortest)
    }

    /// The longest length of the step, or nil when the graph counted it in a unit this build does not know.
    public var longestDuration: Duration? {
        duration(of: longest)
    }

    private func duration(of amount: Double) -> Duration? {
        guard let known = Unit(rawValue: unit) else {
            return nil
        }
        return .seconds(amount * known.seconds)
    }
}
