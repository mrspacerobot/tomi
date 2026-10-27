/// Where a cook is in the adapted recipe while walking it one step at a time. The steps are the server's, in the
/// server's order, and are never changed here. The walk never goes past either end.
public struct StepWalk: Hashable, Sendable {
    public let steps: [AdaptedStep]
    private let index: Int

    /// Nil for a recipe with no steps: there is nothing to walk, and that is never read as "finished".
    public init?(steps: [AdaptedStep]) {
        guard !steps.isEmpty else { return nil }
        self.steps = steps
        index = 0
    }

    private init(steps: [AdaptedStep], index: Int) {
        self.steps = steps
        self.index = index
    }

    public var current: AdaptedStep { steps[index] }

    /// The place in the walk, counted from one for the cook.
    public var position: Int { index + 1 }

    public var count: Int { steps.count }

    public var isFirst: Bool { index == 0 }

    public var isLast: Bool { index == steps.count - 1 }

    public func advanced() -> StepWalk {
        if isLast {
            return self
        }
        return StepWalk(steps: steps, index: index + 1)
    }

    public func steppedBack() -> StepWalk {
        if isFirst {
            return self
        }
        return StepWalk(steps: steps, index: index - 1)
    }
}
