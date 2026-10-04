/// The cook's progress through the whole menu. Computed from the cook log by `ProgressRules`, never stored.
public struct CookProgress: Hashable, Sendable {
    /// One entry per skill in the catalog, in menu order.
    public let skills: [SkillProgress]

    public func skill(_ id: SkillID) -> SkillProgress? {
        skills.first { $0.skill == id }
    }

    /// The skill to cook next: the cook's choice while it is served and not mastered,
    /// otherwise the first such skill in menu order. Nil when nothing is left to cook.
    public func focus(preferring chosen: SkillID?) -> SkillID? {
        if let chosen, canBeFocus(chosen) {
            return chosen
        }
        guard let firstInMenuOrder = skills.first(where: { $0.status == .served }) else {
            return nil
        }
        return firstInMenuOrder.skill
    }

    private func canBeFocus(_ id: SkillID) -> Bool {
        guard let progress = skill(id) else {
            return false
        }
        return progress.status == .served
    }
}
