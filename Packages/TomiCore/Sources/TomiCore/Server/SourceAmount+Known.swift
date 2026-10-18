extension SourceAmount {
    /// The units the graph counts with that the lesson library does not have.
    enum GraphUnit: String {
        case clove
    }

    /// The amount as a lesson amount, or nil when its unit is not one the lesson units name.
    public var measured: Amount? {
        guard let known = AmountUnit(rawValue: unit) else {
            return nil
        }
        return Amount(value, known)
    }

    /// How many cloves, or nil when the amount is not a whole number of cloves.
    public var wholeCloves: Int? {
        guard GraphUnit(rawValue: unit) == .clove, value.rounded() == value, value > 0 else {
            return nil
        }
        return Int(value)
    }
}
