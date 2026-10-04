/// One step of a lesson: what to do, an optional tip, the scene drawn with it and an optional timer.
/// A scene is decoration, never a safety fact. A step with no scene, or with one this build does not know,
/// is shown with the plain drawing, so a missing picture never hides a lesson.
public struct LessonStep: Hashable, Codable, Sendable {
    /// No timer may run longer than four hours. This is the one place that says so.
    public static let longestTimerSeconds = 4 * 60 * 60

    public var text: LocalizedText
    public var tip: LocalizedText?
    /// The scene as the file writes it, or nil when the step names none because no scene of the kit fits it.
    /// It is kept as written, so a scene added by a newer library still loads on an older app.
    public var sceneName: String?
    /// How long the step's timer runs, or nil for a step without one.
    public var timerSeconds: Int?

    /// The scene to draw, or nil for the plain drawing: the step names no scene, or one this build does not know.
    public var scene: StepScene? {
        guard let sceneName else {
            return nil
        }
        return StepScene(rawValue: sceneName)
    }

    /// The scene name when it is one this build cannot draw. A lesson we ship must have none of these;
    /// one from a newer library may, and is then shown with the plain drawing.
    public var unknownSceneName: String? {
        guard let sceneName, scene == nil else {
            return nil
        }
        return sceneName
    }

    /// The names of the fields in the file.
    enum CodingKeys: String, CodingKey {
        case text
        case tip
        case sceneName = "scene"
        case timerSeconds
    }
}
