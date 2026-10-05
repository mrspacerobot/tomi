import TomiCore

extension OnboardingModel {
    /// The names of what the cook ticked, in the order the table lists them. An item the table does not list
    /// has no name to show, but is still saved and still avoided.
    func avoidedNames(in table: IngredientTable) -> [String] {
        var names: [String] = []
        for item in table.avoidItems where avoidAnswer.isTicked(item.id) {
            names.append(item.name.forCook)
        }
        return names
    }
}
