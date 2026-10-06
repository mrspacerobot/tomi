import RealityKit

/// Owns the character and receives elapsed render time. Nothing here opens a camera or microphone.
final class CompanionRig {
    let root = Entity()
    let body = Entity()
    let face = CompanionFace()
    let leftArm = CompanionArm.make(side: -1)
    let rightArm = CompanionArm.make(side: 1)
    var presentation = CompanionPresentation()
    var elapsed: Float = 0
    var pose = CompanionState.idle.pose
    var subscription: EventSubscription?

    init() {
        body.addChild(CompanionSculpt.oval([0.68, 0.63, 0.55], at: .zero, material: CompanionMaterial.tomato))
        CompanionSculpt.attach([leftArm, rightArm, CompanionHat.make()], to: body)
        CompanionDetails.add(to: body)
        face.attach(to: body)
        root.addChild(body)
        apply(pose)
    }

    func configure(_ value: CompanionPresentation) {
        presentation = value
        if !value.moving {
            pose = value.state.pose
            apply(pose)
        }
    }

    func advance(by delta: Float) {
        guard presentation.moving else { return }
        let step = min(max(delta, 0), 0.05)
        elapsed += step
        let target = CompanionMotion.pose(state: presentation.state, elapsed: elapsed, moving: true)
        pose.approach(target, fraction: 1 - exp(-step * 10))
        apply(pose)
    }

    func stop() {
        subscription?.cancel()
        subscription = nil
    }
}
