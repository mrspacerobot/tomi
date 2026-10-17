/// The cupboard question. Like the kitchen, it starts from what the server assumes, and the first change
/// answers it with exactly what the cook sees.
extension CookProfile {
    /// The cupboard as the question shows it: the cook's staples once answered, or what the server assumes.
    public func cupboard(assumedUntilAnswered assumed: Set<OptionID>) -> Set<OptionID> {
        guard cupboardAnswered else {
            return assumed
        }
        return cupboardStaples
    }

    /// Answers the question as it stands, for a cook who saves it without changing anything.
    public mutating func answerCupboard(assumedUntilAnswered assumed: Set<OptionID>) {
        change(assumedUntilAnswered: assumed) { _ in }
    }

    public mutating func toggleCupboardStaple(_ ingredient: OptionID, assumedUntilAnswered assumed: Set<OptionID>) {
        change(assumedUntilAnswered: assumed) { $0.toggle(ingredient) }
    }

    public mutating func addCupboardStaple(_ ingredient: OptionID, assumedUntilAnswered assumed: Set<OptionID>) {
        change(assumedUntilAnswered: assumed) { $0.insert(ingredient) }
    }

    public mutating func removeCupboardStaple(_ ingredient: OptionID, assumedUntilAnswered assumed: Set<OptionID>) {
        change(assumedUntilAnswered: assumed) { $0.remove(ingredient) }
    }

    private mutating func change(
        assumedUntilAnswered assumed: Set<OptionID>,
        _ change: (inout Set<OptionID>) -> Void
    ) {
        var cupboard = cupboard(assumedUntilAnswered: assumed)
        change(&cupboard)
        cupboardStaples = cupboard
        cupboardAnswered = true
    }
}
