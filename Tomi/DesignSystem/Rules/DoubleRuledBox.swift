import SwiftUI

/// The box that holds tonight's special: a double rule all round, a red label set into its top edge and
/// whatever the screen puts inside, centred (`.b-special` in the design kit).
struct DoubleRuledBox<Content: View>: View {
    /// The kit's padding inside the box, the space between the things in it, and the room it leaves
    /// between the label in the top edge and the first of them.
    static var topPadding: CGFloat { 26 }
    static var sidePadding: CGFloat { 18 }
    static var contentSpacing: CGFloat { 10 }
    static var gapUnderFlag: CGFloat { 16 }

    var flag: LocalizedStringResource?
    @ViewBuilder let content: Content
    /// The outline runs through the middle of the label, however many lines the label takes.
    @State private var flagHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            if let flag {
                BoxFlag(words: flag)
                    .padding(.horizontal, Self.sidePadding)
                    .onGeometryChange(for: CGFloat.self, of: \.size.height) { flagHeight = $0 }
            }
            VStack(spacing: Self.contentSpacing) { content }
                .multilineTextAlignment(.center)
                .padding(.top, topGap)
                .padding([.horizontal, .bottom], Self.sidePadding)
        }
        .frame(maxWidth: .infinity)
        .background(DoubleRuledFrame().padding(.top, flagHeight / 2))
    }

    private var topGap: CGFloat {
        if flag == nil {
            return Self.topPadding
        }
        return Self.gapUnderFlag
    }
}

#Preview("Light") {
    DoubleRuledBox(flag: .sampleBoxFlag) {
        Text(.sampleBoxTitle)
            .textStyle(.title)
        Text(.sampleBoxDescription)
            .textStyle(.description)
    }
    .padding()
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text, no flag") {
    DoubleRuledBox {
        Text(.sampleBoxTitle)
            .textStyle(.title)
    }
    .padding()
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
