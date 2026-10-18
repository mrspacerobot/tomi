import Foundation
import TomiCore

/// The safe plan the fake server makes for a lesson: the first listed swap applied, or else the last
/// ingredient left out. All but the first ingredient are to buy.
nonisolated struct FakeSafePlan {
    let lesson: Lesson

    var wire: FakeOffer.Wire {
        [
            "ingredients": planned.map(named),
            "substitutions": swaps,
            "omittedParts": omitted,
            "missing": planned.dropFirst().map(named),
            "equipment": lesson.equipment.map(\.rawValue).sorted().map(namedEquipment),
        ]
    }

    private var swap: LessonSwap? {
        lesson.swaps.first
    }

    private var planned: [String] {
        var kept = lesson.ingredients.map(\.ingredient.rawValue)
        guard let swap else {
            return Array(kept.dropLast())
        }
        if let position = kept.firstIndex(of: swap.ingredient.rawValue) {
            kept[position] = swap.replacement.ingredient.rawValue
        }
        return kept
    }

    private var omitted: [String] {
        guard swap == nil, let last = lesson.ingredients.last else {
            return []
        }
        return [last.ingredient.rawValue]
    }

    private var swaps: [FakeOffer.Wire] {
        guard let swap else {
            return []
        }
        return [
            [
                "removed": named(swap.ingredient.rawValue),
                "added": named(swap.replacement.ingredient.rawValue),
                "ratio": ["by": "volume", "original": 1, "stand_in": 1],
                "caveat": "Not the same flavour, so taste before you serve.",
            ]
        ]
    }

    private func named(_ id: String) -> FakeOffer.Wire {
        ["id": FakeGraphID.ingredient(id), "name": FakeOptions.name(of: id)]
    }

    private func namedEquipment(_ id: String) -> FakeOffer.Wire {
        ["id": FakeGraphID.equipment(id), "name": FakeOptions.name(of: id)]
    }
}
