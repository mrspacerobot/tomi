/// Where an ingredient of a dish comes from (`.r-use` and `.r-miss` in the design kit).
nonisolated enum UseTagKind: CaseIterable, Sendable {
    /// The cook has it in the fridge.
    case fridge
    /// The cook has it in the cupboard.
    case cupboard
    /// The cook does not have it. Drawn larger, with a dashed red edge.
    case missing
}
