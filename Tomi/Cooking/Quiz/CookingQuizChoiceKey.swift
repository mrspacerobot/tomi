import SwiftUI

/// A label for the order of a choice. Verdicts only come from the server.
struct CookingQuizChoiceKey: View {
    let position: Int

    var body: some View {
        Text(words)
            .textStyle(.answerKey, color: ink)
            .padding(ShowSize.compact)
            .frame(minWidth: TouchTarget.minimum, minHeight: TouchTarget.minimum)
            .background(fill.color, in: .capsule)
            .accessibilityHidden(true)
    }

    private var words: LocalizedStringResource {
        switch position {
        case 0: .showtimeChoiceA
        case 1: .showtimeChoiceB
        case 2: .showtimeChoiceC
        default: .showtimeChoiceNumber(position + 1)
        }
    }

    private var fill: ColorRole {
        switch position {
        case 1: .showCorrect
        case 2: .showBlue
        default: .showRed
        }
    }

    private var ink: ColorRole {
        if fill == .showCorrect { return .showInk }
        return .showWhite
    }
}

#Preview { CookingQuizChoiceKey(position: 0) }
