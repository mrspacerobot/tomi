import RealityKit

/// Shared rounded strips form a smile whose corners stay higher as the mouth opens.
enum CompanionMouth {
    static func make() -> Entity {
        let mouth = Entity()
        for _ in 0..<13 {
            mouth.addChild(CompanionSculpt.oval(.one, at: .zero, material: CompanionMaterial.ink))
        }
        return mouth
    }

    static func apply(_ opening: Float, to mouth: Entity) {
        for (index, strip) in mouth.children.enumerated() {
            shape(strip, index: index, opening: opening)
        }
    }

    private static func shape(_ strip: Entity, index: Int, opening: Float) {
        let across = Float(index - 6) / 6
        let curve = 1 - across * across
        let height = opening * curve / 2
        strip.position = [across * 0.13, -0.17 - 0.015 * curve - height, 0.535]
        strip.scale = [0.016, 0.009 + height, 0.016]
    }
}
