import SwiftUI

struct ShowEmailField<Content: View>: View {
    let title: LocalizedStringResource
    var failed = false
    @ViewBuilder let content: Content

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.compact) {
                Text(title).textStyle(.showLabel, color: .showMuted).accessibilityHidden(true)
                content.textStyle(.showBodyStrong).multilineTextAlignment(.leading)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: Radius.showCard).strokeBorder(outline, lineWidth: RuleWeight.showRing)
        }
    }

    private var outline: Color {
        if failed { return ColorRole.showError.color }
        return .clear
    }
}

#Preview { ShowEmailField(title: .authEmailPrompt) { Text(verbatim: "cook@example.com") } }
