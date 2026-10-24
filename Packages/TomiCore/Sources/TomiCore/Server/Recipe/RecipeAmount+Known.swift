import Foundation

extension RecipeAmount {
    /// The things the graph counts that the lesson library does not have a unit for.
    public enum CountUnit: String, CaseIterable, Sendable {
        case clove
        case serving
        case pinch
        case sprig
        case slice
        case leaf
    }

    /// The units the graph counts with that are a weight or volume the lesson units do not name.
    enum LargeUnit: String {
        case kilogram
        case litre
    }

    /// The amount as a lesson amount, or nil when its unit is not one the lesson units name.
    public var measured: Amount? {
        guard let known = AmountUnit(rawValue: unit) else {
            return nil
        }
        return Amount(value, known)
    }

    /// The amount in kilograms or litres, or nil when its unit is neither.
    public var large: Measurement<Dimension>? {
        guard let known = LargeUnit(rawValue: unit) else {
            return nil
        }
        switch known {
        case .kilogram: return Measurement<Dimension>(value: value, unit: UnitMass.kilograms)
        case .litre: return Measurement<Dimension>(value: value, unit: UnitVolume.liters)
        }
    }

    /// How many of a counted thing, or nil when the amount is not counted or not a whole number.
    public func whole(_ counted: CountUnit) -> Int? {
        guard CountUnit(rawValue: unit) == counted, value.rounded() == value, value > 0 else {
            return nil
        }
        return Int(value)
    }

    /// How many cloves, or nil when the amount is not a whole number of cloves.
    public var wholeCloves: Int? {
        whole(.clove)
    }

    /// How many servings, or nil when the amount is not a whole number of servings.
    public var wholeServings: Int? {
        whole(.serving)
    }
}
