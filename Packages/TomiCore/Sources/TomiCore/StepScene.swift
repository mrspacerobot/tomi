/// The drawing shown with a lesson step. A closed list: the actions of the scene kit in
/// `docs/design/src/scenes3.py`, in the kit's order. A step names the one that shows its action, or none.
/// A new scene is drawn in the kit first, then added here, and released in the app before a library uses it.
/// Until then an older app shows that step with the plain drawing.
/// The raw values are written in the library, so never rename or reuse one.
public enum StepScene: String, CaseIterable, Hashable, Codable, Sendable {
    case chop
    case crack
    case whisk
    case sear
    case flip
    case toss
    case stir
    case deglaze
    case simmer
    case boil
    case drain
    case oven
    case rest
    case plate
    case checkTemperature = "temp"
}
