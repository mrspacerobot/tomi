import Foundation
import TomiCore

/// The recipe the fake server writes for the cook, and the changes it made, in the wire shape of the real one.
nonisolated struct FakeRecipe {
    /// Steps at least this long get a made-up heat and a safety point, so the screen shows both.
    private static let longStepSeconds = 300

    let adaptation: FakeAdaptation

    var recipeWire: FakeSuggestion.Wire {
        [
            "yields": ["unit": "serving", "value": 2],
            "ingredients": adaptation.lines.map(line),
            "steps": adaptation.steps.enumerated().map { step($0.element, number: $0.offset + 1) },
        ]
    }

    var changesWire: FakeSuggestion.Wire {
        [
            "swaps": swapsWire,
            "leftOut": leftOutWire,
        ]
    }

    /// The swap, shared with the safe plan, which still carries it.
    var swapsWire: [FakeSuggestion.Wire] {
        guard let swap = adaptation.swap else {
            return []
        }
        return [
            [
                "removed": Self.named(swap.ingredient.rawValue),
                "added": Self.named(swap.replacement.ingredient.rawValue),
                "ratio": ["by": "volume", "original": 1, "stand_in": 1],
                "caveat": "Not the same flavour, so taste before you serve.",
            ]
        ]
    }

    private var leftOutWire: [FakeSuggestion.Wire] {
        guard let leftOut = adaptation.leftOut else {
            return []
        }
        let id = leftOut.ingredient.rawValue
        return [["part": id, "name": FakeOptions.name(of: id), "ingredients": [Self.named(id)]]]
    }

    private func line(_ line: FakeAdaptation.Line) -> FakeSuggestion.Wire {
        let id = line.used.ingredient.rawValue
        var wire = Self.named(id)
        wire["part"] = line.part.rawValue
        wire["amount"] = ["unit": line.used.metric.unit.rawValue, "value": line.used.metric.value]
        wire["forms"] = [FakeSuggestion.Wire]()
        return wire
    }

    private func step(_ step: FakeAdaptation.Step, number: Int) -> FakeSuggestion.Wire {
        var wire: FakeSuggestion.Wire = ["number": number, "text": step.text]
        wire["time"] = NSNull()
        wire["temperature"] = NSNull()
        wire["safetyPoints"] = [String]()
        guard let seconds = step.seconds else {
            return wire
        }
        wire["time"] = ["unit": "second", "value": seconds]
        return withHeat(wire, seconds: seconds)
    }

    private func withHeat(_ wire: FakeSuggestion.Wire, seconds: Int) -> FakeSuggestion.Wire {
        guard seconds >= Self.longStepSeconds else {
            return wire
        }
        var hot = wire
        hot["temperature"] = ["unit": "celsius", "value": 180]
        hot["safetyPoints"] = ["doneness"]
        return hot
    }

    static func named(_ id: String) -> FakeSuggestion.Wire {
        ["id": FakeGraphID.ingredient(id), "name": FakeOptions.name(of: id)]
    }
}
