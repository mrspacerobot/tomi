import Foundation

/// How the whole figure hops, squashes, stretches and leans, about the point between its feet.
nonisolated struct CompanionBodyPose: CompanionBlendable {
    /// Up is negative, in grid units.
    var lift: Double = 0
    var stretchX: Double = 1
    var stretchY: Double = 1
    /// Degrees; negative leans to the cook's left.
    var tilt: Double = 0

    static let rest = CompanionBodyPose()

    func blended(toward target: CompanionBodyPose, by fraction: Double) -> CompanionBodyPose {
        CompanionBodyPose(
            lift: lift.blended(toward: target.lift, by: fraction),
            stretchX: stretchX.blended(toward: target.stretchX, by: fraction),
            stretchY: stretchY.blended(toward: target.stretchY, by: fraction),
            tilt: tilt.blended(toward: target.tilt, by: fraction)
        )
    }
}
