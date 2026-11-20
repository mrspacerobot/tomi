import SwiftUI
import TomiCore

/// One kind line about progress the server has not counted yet. It never names a number Tomi worked out.
struct HomeProgressNote: View {
    let note: ProgressNote

    var body: some View {
        ShowCard {
            VStack(alignment: .leading, spacing: ShowSize.gap) {
                ShowLowerThird(title: .offAirBadge).accessibilityIdentifier("off-air-badge")
                Text(words).textStyle(.showText).accessibilityIdentifier("home-progress-note")
            }
        }
    }

    private var words: LocalizedStringResource {
        switch note {
        case .unsentCooks(let count): .homeProgressUnsentCooks(count)
        case .showsWhenOnline: .homeProgressShowsOnline
        case .thisWeekWhenOnline: .homeProgressWeekShowsOnline
        }
    }
}

#Preview {
    VStack(spacing: Spacing.large) {
        HomeProgressNote(note: .unsentCooks(1))
        HomeProgressNote(note: .unsentCooks(3))
        HomeProgressNote(note: .showsWhenOnline)
        HomeProgressNote(note: .thisWeekWhenOnline)
    }
    .padding()
    .background { ShowStage() }
}
