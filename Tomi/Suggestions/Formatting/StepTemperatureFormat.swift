import Foundation
import TomiCore

/// The heat of a step written with Foundation's measurement formatter. A unit this build does not know is not shown.
nonisolated enum StepTemperatureFormat {
    static func text(for temperature: StepTemperature) -> String? {
        guard let measurement = temperature.measurement else {
            return nil
        }
        return measurement.formatted(.measurement(width: .abbreviated, usage: .asProvided))
    }
}
