/// One step of a lesson: what to do, an optional tip, the scene drawn with it and an optional timer.
public struct LessonStep: Hashable, Codable, Sendable {
    /// No timer may run longer than four hours. This is the one place that says so.
    public static let longestTimerSeconds = 4 * 60 * 60

    public var text: LocalizedText
    public var tip: LocalizedText?
    /// The scene as the file writes it. It is kept as written, so that a name outside the closed list
    /// reaches the validator and is reported with its lesson, instead of failing somewhere in decoding.
    public var sceneName: String
    /// How long the step's timer runs, or nil for a step without one.
    public var timerSeconds: Int?

    /// The scene to draw, or nil when the file names one this build does not know.
    public var scene: StepScene? {
        StepScene(rawValue: sceneName)
    }

    /// The names of the fields in the file.
    enum CodingKeys: String, CodingKey {
        case text
        case tip
        case sceneName = "scene"
        case timerSeconds
    }
}
