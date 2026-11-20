import SwiftUI

struct EmailAuthPortrait: View {
    let hasProblem: Bool

    var body: some View {
        TomiMascot(mood: mood)
            .frame(width: ShowStageSize.backstageHost, height: ShowStageSize.backstageHost)
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }

    private var mood: CompanionState {
        if hasProblem { return .thinking }
        return .idle
    }
}

#Preview { EmailAuthPortrait(hasProblem: true).background { ShowStage() } }
