/// Where a skill stands on the menu, as the cook sees it.
public enum SkillStatus: Hashable, Sendable {
    /// Not on offer yet. `missing` lists the prerequisites whose first level is still to be completed.
    case locked(missing: [SkillID])
    /// On offer, with at least one level still to complete.
    case served
    /// Every level is complete.
    case mastered
}
