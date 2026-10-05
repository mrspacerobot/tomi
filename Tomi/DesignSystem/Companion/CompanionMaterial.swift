import RealityKit

/// Matte pigments from the approved Tasting menu drawing kit. Lighting supplies their depth.
enum CompanionMaterial {
    static let tomato = material([0.894, 0.278, 0.184])
    static let ink = material([0.114, 0.212, 0.565])
    static let cream = material([0.984, 0.980, 0.961])
    static let leaf = material([0.576, 0.647, 0.890])

    private static func material(_ rgb: SIMD3<Double>) -> SimpleMaterial {
        SimpleMaterial(
            color: .init(red: rgb.x, green: rgb.y, blue: rgb.z, alpha: 1),
            roughness: 0.85,
            isMetallic: false
        )
    }
}
