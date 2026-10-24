/// One step of the recipe written for this cook. The server counts the steps from one again after it drops one,
/// so a step left out leaves no gap.
public struct AdaptedStep: Hashable, Decodable, Sendable {
    public let number: Int
    public let text: String
    /// How long the step takes, or nil when it has no time.
    public let time: StepTime?
    /// How hot, or nil when the step has no temperature.
    public let temperature: StepTemperature?
    /// The safety points the server attaches to this step, exactly as it names them. Required: a missing list is
    /// never read as "no safety points".
    public let safetyPoints: [String]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(Int.self, forKey: .number)
        text = try container.decode(String.self, forKey: .text)
        time = try container.decodeIfPresent(StepTime.self, forKey: .time)
        temperature = try container.decodeIfPresent(StepTemperature.self, forKey: .temperature)
        safetyPoints = try container.decode([String].self, forKey: .safetyPoints)
    }

    enum CodingKeys: String, CodingKey {
        case number, text, time, temperature, safetyPoints
    }
}

extension AdaptedStep {
    /// The safety points as plain words. The server names them by id, such as `raw-or-lightly-cooked-egg`; the app
    /// makes the id readable and adds nothing of its own.
    public var safetyPointWords: [String] {
        safetyPoints.map { OptionID(rawValue: $0).readable }
    }
}
