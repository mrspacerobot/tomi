import TomiCore

/// What the cook confirms: the scan's items and what they typed. Only ticked items with an ingredient count.
struct ConfirmList: Equatable {
    var items: [ConfirmItem] = []

    var confirmedIngredients: Set<OptionID> {
        var ids: Set<OptionID> = []
        for item in items where item.isTicked {
            if let ingredient = item.ingredient {
                ids.insert(ingredient.id)
            }
        }
        return ids
    }

    mutating func toggle(_ id: ConfirmItem.ID) {
        guard let position = items.firstIndex(where: { $0.id == id }), items[position].ingredient != nil else {
            return
        }
        items[position].isTicked.toggle()
    }

    /// Adds the ingredient ticked, or ticks it when it is already on the list.
    mutating func add(_ ingredient: NamedOption) {
        if let position = items.firstIndex(where: { $0.ingredient?.id == ingredient.id }) {
            items[position].isTicked = true
        } else {
            items.append(ConfirmItem(typed: ingredient))
        }
    }
}
