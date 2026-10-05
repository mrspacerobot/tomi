import RealityKit

enum CompanionDetails {
    static func add(to body: Entity) {
        for side: Float in [-1, 1] { addSide(side, to: body) }
        body.addChild(CompanionSculpt.oval([0.06, 0.14, 0.08], at: [0, 0.49, 0.43], material: CompanionMaterial.leaf))
    }

    private static func addSide(_ side: Float, to body: Entity) {
        let tomato = CompanionMaterial.tomato
        let blue = CompanionMaterial.leaf
        let foot = CompanionSculpt.oval([0.17, 0.095, 0.22], at: [side * 0.26, -0.67, 0.10], material: tomato)
        let leaf = CompanionSculpt.oval([0.24, 0.06, 0.12], at: [side * 0.27, 0.56, 0.30], material: blue)
        CompanionSculpt.turn(leaf, by: side * -0.30)
        CompanionSculpt.attach([foot, leaf], to: body)
    }
}
