import SwiftUI
import TomiCore

/// Tonight's special and up to two alternatives, each only shown when the server checked it for this cook.
struct SuggestionsView: View {
    let menu: TonightsMenu
    let options: LibraryOptions
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ShowSize.rowGap) {
                Text(.fridgeMenuTitle).textStyle(.showTitle).accessibilityIdentifier("fridge-menu-title")
                if let special = menu.special {
                    SuggestionCard(suggestion: special, options: options, flag: .suggestionsKicker) {
                        path.append(.suggestion(special))
                    }
                }
                AlternativesList(suggestions: menu.alternatives, options: options, path: $path)
            }
            .padding(ShowSize.edge)
        }
    }
}
