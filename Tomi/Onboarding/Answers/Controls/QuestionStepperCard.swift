import SwiftUI

struct QuestionStepperCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ShowCard { content.foregroundStyle(ColorRole.showInk.color) }
    }
}

#Preview {
    QuestionStepperCard { Text(.questionTableServings(2)) }
}
