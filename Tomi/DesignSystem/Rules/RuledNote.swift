import SwiftUI

/// A short result under a question: a title and its words on the wash, with a rule down the leading edge
/// (`.q-res` in the design kit). The title says the state in words, so the rule's colour is never the only sign.
/// VoiceOver reads the note as one element.
struct RuledNote<Content: View>: View {
    let title: LocalizedStringResource
    let rule: ColorRole
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(title).textStyle(.dish)
            content
        }
        .padding(.vertical, Spacing.small)
        .padding(.leading, Spacing.small + RuleWeight.double)
        .padding(.trailing, Spacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorRole.wash.color)
        .overlay(alignment: .leading) {
            Rectangle().fill(rule.color).frame(width: RuleWeight.double)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Light") {
    RuledNote(title: .sampleBoxTitle, rule: .cobalt) {
        Text(.sampleBoxDescription).textStyle(.body)
    }
    .padding()
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text") {
    RuledNote(title: .sampleBoxTitle, rule: .stampRed) {
        Text(.sampleBoxDescription).textStyle(.body)
    }
    .padding()
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
