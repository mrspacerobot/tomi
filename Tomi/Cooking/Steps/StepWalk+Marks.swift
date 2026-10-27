import TomiCore

extension StepWalk {
    /// The step the cook is on, among all the steps.
    var marks: CookingMarks {
        CookingMarks(position: position, count: count)
    }
}
