/// XP is counted from the cook log every time it is asked for, never kept as a running total.
extension Sequence where Element == CookEntry {
    /// The XP of every finished cook in the log. An entry stopped early earns nothing and a repeated id earns once.
    /// A skill or level the catalog does not know still earns, as it does for the streak: the cook did cook.
    public var earnedXP: Int {
        var total = 0
        for cook in finishedCooks {
            total += GameRules.xp(for: cook.session.result)
        }
        return total
    }
}
