import SwiftUI
import TomiCore

struct AvoidSearchResult: View {
    let item: AvoidOption
    let add: () -> Void

    var body: some View {
        Button(action: add) {
            ShowCard {
                VStack(alignment: .leading, spacing: ShowSize.compact) {
                    Text(verbatim: item.name).textStyle(.showBodyStrong)
                    Text(label).textStyle(.showMeta, color: .showRed)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("avoid-add-" + item.id.rawValue)
    }

    private var label: LocalizedStringResource {
        switch item.kind {
        case .allergen: .openingAddAllergy
        case .choice: .openingAddRatherNot
        }
    }
}

#Preview { AvoidSearchResult(item: AvoidOption(id: "fake", name: "Nuts", kind: .allergen), add: {}) }
