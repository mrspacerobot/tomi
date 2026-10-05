import SwiftUI

/// The small tag naming an ingredient a dish uses, and showing whether the cook has it. It is read, not
/// tapped. VoiceOver reads the name and then where the ingredient comes from.
struct UseTag: View {
    let name: String
    let kind: UseTagKind

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Radius.tag)
        let edge = StrokeStyle(lineWidth: kind.outlineWeight, dash: kind.outlineDash)
        Text(name)
            .textStyle(.tag, color: kind.text)
            .padding(.horizontal, kind.sidePadding)
            .frame(minHeight: kind.minimumHeight)
            .background(shape.fill(ColorRole.paper.color))
            .overlay(shape.strokeBorder(kind.outline.color, style: edge))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(name))
            .accessibilityValue(kind.value)
    }
}

#Preview("Light") {
    FlowLayout(spacing: ChipFace.gap) {
        UseTag(name: String(localized: .sampleTagFridge), kind: .fridge)
        UseTag(name: String(localized: .sampleTagCupboard), kind: .cupboard)
        UseTag(name: String(localized: .sampleTagMissing), kind: .missing)
    }
    .padding()
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text") {
    FlowLayout(spacing: ChipFace.gap) {
        ForEach(UseTagKind.allCases, id: \.self) { kind in
            UseTag(name: String(localized: .sampleTagFridge), kind: kind)
        }
    }
    .padding()
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
