/// The drawing shown with a lesson step. A closed list: the actions of the scene kit in
/// `docs/design/src/scenes3.py`, in the kit's order. A lesson may only name one of these.
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
    case wilt
    case scramble
    case fill
    case roll
    case mount
}
