extension LibraryOptions {
    /// The names of the diet and avoid items an offer was checked against, diet first, avoid items in id order.
    /// An id this list does not name is shown as its id made readable: the cook still sees what was checked.
    public func names(checkedFor checked: CheckedRestrictions) -> [String] {
        var names: [String] = []
        if let diet = checked.diet {
            names.append(diets.first { $0.id == diet }?.name ?? diet.readable)
        }
        for item in checked.avoid.sorted() {
            names.append(avoidItems.first { $0.id == item }?.name ?? item.readable)
        }
        return names
    }
}
