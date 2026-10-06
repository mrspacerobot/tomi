import RealityKit
import SwiftUI

extension CompanionRig {
    /// Updates resume a preserved view after re-entry. Weak capture avoids an entity/subscription cycle.
    func listen(to content: RealityViewCameraContent, moving: Bool) {
        guard moving else { stop(); return }
        guard subscription == nil else { return }
        subscription = content.subscribe(to: SceneEvents.Update.self) { [weak self] event in
            self?.advance(by: Float(event.deltaTime))
        }
    }
}
