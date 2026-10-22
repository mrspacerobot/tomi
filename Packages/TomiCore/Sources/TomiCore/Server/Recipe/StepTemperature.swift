import Foundation

/// The heat a step asks for, as the server sends it: a number and the unit it is counted in.
public struct StepTemperature: Hashable, Decodable, Sendable {
    public let value: Double
    public let unit: String

    public init(value: Double, unit: String) {
        self.value = value
        self.unit = unit
    }
}

extension StepTemperature {
    /// The units of temperature the server writes. A temperature in any other unit is not shown, never guessed.
    enum Unit: String {
        case celsius
        case fahrenheit

        var dimension: UnitTemperature {
            switch self {
            case .celsius: .celsius
            case .fahrenheit: .fahrenheit
            }
        }
    }

    /// The temperature to format, or nil when the server counted it in a unit this build does not know.
    public var measurement: Measurement<UnitTemperature>? {
        guard let known = Unit(rawValue: unit) else {
            return nil
        }
        return Measurement(value: value, unit: known.dimension)
    }
}
