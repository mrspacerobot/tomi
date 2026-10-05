import Foundation

/// A complete pose. Static poses carry the same meaning when animation is disabled.
nonisolated struct CompanionPose: Equatable {
    var yaw: Float = 0
    var tilt: Float = 0
    var lift: Float = 0
    var squash: Float = 1
    var leftArm: Float = -0.45
    var rightArm: Float = 0.45
    var rightArmDepth: Float = 0.04
    var gaze: SIMD2<Float> = .zero
    var brow: Float = 0
    var mouth: Float = 0.045
    var eyes: Float = 1
}
