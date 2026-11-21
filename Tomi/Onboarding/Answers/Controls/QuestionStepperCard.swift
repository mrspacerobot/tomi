import SwiftUI

struct QuestionStepperCard<Content: View>: View {
    @Environment(\.usesShowQuestionStyle) private var showStyle
    @ViewBuilder let content: Content

    var body: some View {
        if showStyle {
            ShowCard { content.foregroundStyle(ColorRole.showInk.color) }
        } else {
            content
        }
    }
}

#Preview {
    QuestionStepperCard { ServingsStepper(draft: .preview()) }.environment(\.usesShowQuestionStyle, true)
}
