import RealityKit

enum CompanionEye {
    static func make() -> Entity {
        let eye = Entity()
        let pupil = CompanionSculpt.oval([0.067, 0.094, 0.031], at: .zero, material: CompanionMaterial.ink)
        let gleam = CompanionSculpt.oval(
            [0.019, 0.022, 0.012],
            at: [0.020, 0.032, 0.028],
            material: CompanionMaterial.cream
        )
        CompanionSculpt.attach([pupil, gleam], to: eye)
        return eye
    }
}
