import RealityKit

/// The face is separate geometry close to the tomato surface, so it also reads in three-quarter view.
final class CompanionFace {
    let leftEye = CompanionEye.make()
    let rightEye = CompanionEye.make()
    let leftBrow = CompanionSculpt.oval(
        [0.09, 0.018, 0.023],
        at: [-0.21, 0.28, 0.49],
        material: CompanionMaterial.ink
    )
    let rightBrow = CompanionSculpt.oval(
        [0.09, 0.018, 0.023],
        at: [0.21, 0.28, 0.49],
        material: CompanionMaterial.ink
    )
    let mouth = CompanionMouth.make()

    func attach(to body: Entity) {
        CompanionSculpt.attach([leftEye, rightEye, leftBrow, rightBrow, mouth], to: body)
    }

    func apply(_ pose: CompanionPose) {
        leftEye.position = [-0.21 + pose.gaze.x, 0.09 + pose.gaze.y, 0.53]
        rightEye.position = [0.21 + pose.gaze.x, 0.09 + pose.gaze.y, 0.53]
        leftEye.scale.y = pose.eyes
        rightEye.scale.y = pose.eyes
        CompanionSculpt.turn(leftBrow, by: pose.brow)
        CompanionSculpt.turn(rightBrow, by: -pose.brow)
        CompanionMouth.apply(pose.mouth, to: mouth)
    }
}
