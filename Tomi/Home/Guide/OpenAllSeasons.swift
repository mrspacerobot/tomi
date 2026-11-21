import SwiftUI

struct OpenAllSeasons: View {
    var body: some View {
        NavigationLink(value: HomeRoute.seasons) {
            ShowCard {
                Label {
                    Text(.guideAllSeasons).textStyle(.cardTitle)
                } icon: {
                    Image(systemName: "square.grid.2x2")
                        .foregroundStyle(ColorRole.showRed.color)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("open-all-seasons")
    }
}

#Preview { OpenAllSeasons().background { ShowStage() } }
