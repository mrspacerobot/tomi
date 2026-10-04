/// The food at the centre of a dish, drawn in every scene that shows it: searing, flipping, rolling, resting, plating.
/// A closed list, like the scenes: each one is a drawing in the scene kit (`MAINS` in `docs/design/src/scenes3.py`).
/// A lesson names its main once, and its scenes draw that food instead of always showing a chicken thigh.
/// The raw values are written in the library, so never rename or reuse one.
public enum DishMain: String, CaseIterable, Hashable, Codable, Sendable {
    case chicken
    case tofu
    case omelette
}
