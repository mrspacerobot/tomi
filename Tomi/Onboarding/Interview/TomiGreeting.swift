import SwiftUI

struct TomiGreeting: View {
    let question: ProfileQuestion
    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        layout {
            CompanionSlot(state: question.hostPose, side: MascotSize.companionGreeting, appearance: .cookingShow)
            ShowSpeechBubble {
                Text(question.interviewPrompt)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier(question.identifier)
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("onboarding-greeting")
        }
    }

    private var layout: AnyLayout {
        if textSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: ShowSize.gap))
        }
        return AnyLayout(HStackLayout(spacing: ShowSize.rowGap))
    }
}

#Preview { TomiGreeting(question: .diet).padding().background { ShowStage() } }
