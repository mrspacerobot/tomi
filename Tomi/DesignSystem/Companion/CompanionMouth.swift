import OSLog
import RealityKit

/// One smooth surface keeps the smile's corners higher as the mouth opens.
enum CompanionMouth {
    private static let mesh = makeMesh()

    static func make() -> Entity {
        let mouth = ModelEntity(mesh: mesh, materials: [CompanionMaterial.ink])
        mouth.position = [0, -0.17, 0.535]
        return mouth
    }

    static func apply(_ opening: Float, to mouth: Entity) {
        mouth.scale = [0.13, max(opening, 0.01), 0.016]
    }

    private static func makeMesh() -> MeshResource {
        do {
            return try MeshResource.generate(from: [descriptor])
        } catch {
            Logger(category: .companion).error(
                "Smile mesh unavailable: \(error.localizedDescription, privacy: .public)"
            )
            return .generateSphere(radius: 1)
        }
    }

    private static var descriptor: MeshDescriptor {
        let points = positions
        var descriptor = MeshDescriptor()
        descriptor.positions = .init(points)
        descriptor.normals = .init(Array(repeating: SIMD3<Float>(0, 0, 1), count: points.count))
        descriptor.primitives = .triangles(triangles)
        return descriptor
    }

    private static var positions: [SIMD3<Float>] {
        var points: [SIMD3<Float>] = []
        for index in 0...12 {
            let across = Float(index - 6) / 6
            let curve = 1 - across * across
            points.append([across, -0.15 * curve, 0])
            points.append([across, -curve, 0])
        }
        return points
    }

    private static var triangles: [UInt32] {
        var indices: [UInt32] = []
        for segment: UInt32 in 0..<12 {
            append(segment, to: &indices)
        }
        return indices
    }

    private static func append(_ segment: UInt32, to indices: inout [UInt32]) {
        let upper = segment * 2
        let lower = upper + 1
        if segment > 0 { indices += [upper, lower, upper + 2] }
        if segment < 11 { indices += [lower, lower + 2, upper + 2] }
    }
}
