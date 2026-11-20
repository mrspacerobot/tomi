import SwiftUI
import TomiCore

struct AvoidSearchResults: View {
    let query: String
    let options: LibraryOptions
    let add: (AvoidOption) -> Void

    var body: some View {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if !term.isEmpty {
            let matches = options.avoidMatches(for: term)
            if matches.isEmpty {
                Text(.openingAvoidNoMatch).textStyle(.showLede, color: .stageMuted)
            } else {
                ForEach(matches) { item in AvoidSearchResult(item: item) { add(item) } }
            }
        }
    }
}

#Preview { AvoidSearchResults(query: "nut", options: FakeServerData().options, add: { _ in }) }
