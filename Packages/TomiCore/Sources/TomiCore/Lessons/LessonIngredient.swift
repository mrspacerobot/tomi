/// One line of a lesson's ingredient list: an ingredient of the table and how much of it.
/// The amount is written twice, once for each unit system, because a good cups amount is a reviewed
/// kitchen measure ("2 tablespoons"), not a conversion of the grams.
public struct LessonIngredient: Hashable, Codable, Sendable {
    public var ingredient: IngredientID
    public var metric: Amount
    public var cups: Amount

    /// The amount to show a cook who reads recipes in these units.
    public func amount(in units: Units) -> Amount {
        switch units {
        case .metric: metric
        case .cups: cups
        }
    }
}
