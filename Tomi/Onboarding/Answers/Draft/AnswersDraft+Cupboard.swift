import TomiCore

/// The cupboard question over the server's lists. The question lists the everyday staples; whatever else the
/// cook saved is an extra, named from the full ingredient list.
extension AnswersDraft {
    var cupboard: Set<OptionID> {
        answers.cupboard(assumedUntilAnswered: options.assumedStaples)
    }

    /// Saved staples that are not on the question's list, by name.
    var cupboardExtras: [NamedOption] {
        let listed = Set(options.staples.map(\.id))
        let extras = cupboard.subtracting(listed).map { NamedOption(id: $0, name: name(ofIngredient: $0)) }
        return extras.sorted { $0.name < $1.name }
    }

    func toggleStaple(_ id: OptionID) {
        answers.toggleCupboardStaple(id, assumedUntilAnswered: options.assumedStaples)
    }

    func addToCupboard(_ id: OptionID) {
        answers.addCupboardStaple(id, assumedUntilAnswered: options.assumedStaples)
    }

    func removeFromCupboard(_ id: OptionID) {
        answers.removeCupboardStaple(id, assumedUntilAnswered: options.assumedStaples)
    }

    /// A saved id the server no longer lists keeps a plain word: a name is never made up.
    private func name(ofIngredient id: OptionID) -> String {
        if let known = options.ingredients.first(where: { $0.id == id }) {
            return known.name
        }
        return String(localized: .questionCupboardUnknown)
    }
}
