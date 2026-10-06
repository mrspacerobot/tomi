import Foundation

nonisolated struct CompanionPresentation: Equatable {
    var state: CompanionState = .idle
    var turned = false
    var moving = true
}
