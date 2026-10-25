#if DEBUG
    import Foundation

    nonisolated enum CompanionGalleryLaunch {
        static var requested: Bool { ProcessInfo.processInfo.arguments.contains("--companion-gallery") }
        static var still: Bool { ProcessInfo.processInfo.arguments.contains("--companion-still") }

        static var state: CompanionState {
            let arguments = ProcessInfo.processInfo.arguments
            guard let flag = arguments.firstIndex(of: "--companion-state") else { return .idle }
            let next = arguments.index(after: flag)
            guard arguments.indices.contains(next), let state = CompanionState(rawValue: arguments[next]) else {
                return .idle
            }
            return state
        }
    }
#endif
