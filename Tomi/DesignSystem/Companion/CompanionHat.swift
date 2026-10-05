import RealityKit

/// The handoff's tilted toque, built from a band and three soft lobes.
enum CompanionHat {
    static func make() -> Entity {
        let hat = Entity()
        let cream = CompanionMaterial.cream
        let band = ModelEntity(mesh: .generateCylinder(height: 0.20, radius: 0.30), materials: [cream])
        let left = CompanionSculpt.oval([0.25, 0.24, 0.27], at: [-0.25, 0.20, 0], material: cream)
        let center = CompanionSculpt.oval([0.33, 0.31, 0.31], at: [0, 0.30, 0], material: cream)
        let right = CompanionSculpt.oval([0.25, 0.24, 0.27], at: [0.25, 0.20, 0], material: cream)
        CompanionSculpt.attach([band, left, center, right], to: hat)
        hat.position = [0, 0.70, 0]
        CompanionSculpt.turn(hat, by: 0.14)
        return hat
    }
}
