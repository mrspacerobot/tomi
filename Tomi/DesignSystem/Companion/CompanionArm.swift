import RealityKit

/// Shoulder pivot, tapered arm, palm and thumb move together.
enum CompanionArm {
    static func make(side: Float) -> Entity {
        let tomato = CompanionMaterial.tomato
        let pivot = Entity()
        pivot.position = [side * 0.59, -0.03, 0.04]
        let arm = CompanionSculpt.oval([0.065, 0.20, 0.065], at: [0, -0.16, 0], material: tomato)
        let palm = CompanionSculpt.oval([0.105, 0.12, 0.085], at: [0, -0.37, 0], material: tomato)
        let thumb = CompanionSculpt.oval([0.053, 0.07, 0.06], at: [-side * 0.08, -0.33, 0.04], material: tomato)
        CompanionSculpt.attach([arm, palm, thumb], to: pivot)
        return pivot
    }
}
