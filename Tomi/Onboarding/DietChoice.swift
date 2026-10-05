import TomiCore

/// What a cook answered to "what do you eat?". Eating everything is an answer, not a missing one.
enum DietChoice: Hashable {
    case everything
    case diet(DietID)

    /// The choice the saved diet stands for: no diet saved is not yet an answer.
    init?(saved diet: DietID?) {
        guard let diet else {
            return nil
        }
        self = .diet(diet)
    }

    var diet: DietID? {
        switch self {
        case .everything: nil
        case .diet(let id): id
        }
    }
}
