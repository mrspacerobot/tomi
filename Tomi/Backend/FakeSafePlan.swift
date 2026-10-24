import Foundation
import TomiCore

/// The safe plan the fake server makes for a lesson: the ingredients after the adaptation, the swap, the left-out
/// part, and what to buy. All but the first ingredient are to buy.
nonisolated struct FakeSafePlan {
    let adaptation: FakeAdaptation

    var wire: FakeSuggestion.Wire {
        [
            "ingredients": planned.map(FakeRecipe.named),
            "substitutions": FakeRecipe(adaptation: adaptation).swapsWire,
            "omittedParts": omitted,
            "missing": planned.dropFirst().map(FakeRecipe.named),
            "equipment": adaptation.lesson.equipment.map(\.rawValue).sorted().map(namedEquipment),
        ]
    }

    private var planned: [String] {
        adaptation.lines.map(\.used.ingredient.rawValue)
    }

    private var omitted: [String] {
        guard let leftOut = adaptation.leftOut else {
            return []
        }
        return [leftOut.ingredient.rawValue]
    }

    private func namedEquipment(_ id: String) -> FakeSuggestion.Wire {
        ["id": FakeGraphID.equipment(id), "name": FakeOptions.name(of: id)]
    }
}
