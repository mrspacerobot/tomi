import SwiftUI

/// One stat: heading, value and the line under it, centred. VoiceOver reads the three as one line.
struct StatCell: View {
    /// The kit's padding of a cell and the space over its value (`.b-house > div`).
    static let topPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 11
    static let valueTopPadding: CGFloat = 3

    let stat: Stat
    var showStyle = false

    var body: some View {
        VStack(spacing: 0) {
            Text(stat.label)
                .textStyle(labelStyle)
            Text(stat.value)
                .textStyle(valueStyle)
                .padding(.top, Self.valueTopPadding)
            Text(stat.detail)
                .textStyle(detailStyle)
        }
        .multilineTextAlignment(.center)
        .padding(.top, Self.topPadding)
        .padding(.bottom, Self.bottomPadding)
        .padding(.horizontal, Spacing.xxSmall)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }

    private var labelStyle: TextStyle {
        if showStyle { return .showNote }
        return .label
    }

    private var valueStyle: TextStyle {
        if showStyle { return .cardTitle }
        return .value
    }

    private var detailStyle: TextStyle {
        if showStyle { return .showMeta }
        return .caption
    }

}

#Preview {
    StatCell(stat: Stat.samples[0])
        .fixedSize()
        .padding()
        .background(ColorRole.paper.color)
}
