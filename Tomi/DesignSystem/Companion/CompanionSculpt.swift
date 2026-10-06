import RealityKit

/// All organic parts share one mesh. Entity transforms give each part its form.
enum CompanionSculpt {
    private static let sphere = MeshResource.generateSphere(radius: 1)

    static func oval(_ size: SIMD3<Float>, at position: SIMD3<Float>, material: SimpleMaterial) -> ModelEntity {
        let part = ModelEntity(mesh: sphere, materials: [material])
        part.scale = size
        part.position = position
        return part
    }

    static func attach(_ parts: [Entity], to parent: Entity) {
        for part in parts {
            parent.addChild(part)
        }
    }

    static func turn(_ entity: Entity, by angle: Float) {
        entity.orientation = simd_quatf(angle: angle, axis: [0, 0, 1])
    }
}
