#if DEBUG
    import Foundation

    extension CompanionState {
        var label: LocalizedStringResource {
            switch self {
            case .idle: .companionStateIdle
            case .listening: .companionStateListening
            case .thinking: .companionStateThinking
            case .explaining: .companionStateExplaining
            case .celebrating: .companionStateCelebrating
            }
        }

        var line: LocalizedStringResource {
            switch self {
            case .idle: .companionLineIdle
            case .listening: .companionLineListening
            case .thinking: .companionLineThinking
            case .explaining: .companionLineExplaining
            case .celebrating: .companionLineCelebrating
            }
        }
    }
#endif
