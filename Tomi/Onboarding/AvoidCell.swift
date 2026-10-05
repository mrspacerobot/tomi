import SwiftUI
import TomiCore

/// One thing to avoid in the two-column list, from the ingredient table: a tick box and its name.
struct AvoidCell: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.small) {
                TickBox(isTicked: isSelected)
                    .dynamicTypeSize(...TickRowFace.largestBox)
                Text(name)
                    .textStyle(.dish)
                Spacer(minLength: Spacing.none)
            }
            .frame(minHeight: TouchTarget.minimum)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilitySelected(isSelected)
    }
}

#Preview {
    VStack {
        AvoidCell(name: "Nuts", isSelected: true, action: {})
        AvoidCell(name: "Dairy", isSelected: false, action: {})
    }
    .padding()
    .background(ColorRole.paper.color)
}
