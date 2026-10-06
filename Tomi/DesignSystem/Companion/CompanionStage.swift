import RealityKit

/// A virtual studio: fixed camera and broad warm key with a cool fill. No AR session.
enum CompanionStage {
    static func make() -> Entity {
        let studio = Entity()
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 38
        camera.look(at: [0, 0.22, 0], from: [0, 0.30, 4.5], relativeTo: nil)
        let key = light(at: [-2, 3, 4], intensity: 1500)
        let fill = light(at: [3, 1, 2], intensity: 600)
        CompanionSculpt.attach([camera, key, fill], to: studio)
        return studio
    }

    private static func light(at position: SIMD3<Float>, intensity: Float) -> DirectionalLight {
        let light = DirectionalLight()
        light.light.intensity = intensity
        light.look(at: .zero, from: position, relativeTo: nil)
        return light
    }
}
