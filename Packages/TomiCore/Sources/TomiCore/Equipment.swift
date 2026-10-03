/// Something in the cook's kitchen that a lesson may need. A closed list: a lesson is offered only
/// when the kitchen has everything it names.
/// The raw values are saved, so never rename or reuse one.
public enum Equipment: String, CaseIterable, Hashable, Codable, Sendable {
    case stovetop
    case oven
    case microwave
    case thermometer
    case blender
    case riceCooker

    /// What Tomi assumes a kitchen has until the cook says otherwise.
    public static let standard: Set<Equipment> = [.stovetop, .oven, .microwave]
}
