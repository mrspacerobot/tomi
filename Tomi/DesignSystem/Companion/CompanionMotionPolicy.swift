import Foundation

nonisolated enum CompanionMotionPolicy {
    static func moves(reduced: Bool, active: Bool, visible: Bool) -> Bool {
        !reduced && active && visible
    }
}
