#if DEBUG
    import SwiftUI

    struct ShowHostGalleryTile: View {
        var state: CompanionState?

        var body: some View {
            VStack(spacing: ShowSize.gap) {
                ShowHostGalleryFigure(state: state)
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier(identifier)
                Text(label).textStyle(.showLede)
            }
            .frame(maxWidth: .infinity)
        }

        private var label: LocalizedStringResource {
            if let state { return state.label }
            return .showGalleryHostHead
        }

        private var identifier: String {
            if let state { return "host-\(state.rawValue)" }
            return "host-head"
        }
    }

    #Preview("Morning") { ShowHostGalleryTile(state: .thinking).preferredColorScheme(.light) }
    #Preview("Evening, largest text") {
        ShowHostGalleryTile().preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
    }
#endif
