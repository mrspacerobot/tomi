/// The states an ingredient chip is drawn in (`.r-chip` in the design kit). Each differs from the others by
/// a mark, a line or its edge, never by colour alone.
nonisolated enum ChipKind: CaseIterable, Sendable {
    /// A cupboard staple that is always there. It cannot be tapped, and carries a lock.
    case locked
    /// A cupboard ingredient that is switched on. It carries a tick.
    case on
    /// A cupboard ingredient that is switched off. It carries a plus.
    case off
    /// A cupboard ingredient left out for tonight only. Its name is struck through.
    case offTonight
    /// An ingredient of a list, such as the fridge. It carries a cross, and a tap removes it.
    case removable
    /// An ingredient Tomi is not sure he saw. As `removable`, with a dashed red edge and a question mark.
    case unsure
}
