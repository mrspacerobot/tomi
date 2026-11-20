import SwiftUI
import TomiCore

struct HomeCupboardEntry: View {
    @Binding var path: [HomeRoute]
    let profile: CookProfile
    let options: LibraryOptions?

    var body: some View {
        Button {
            path.append(.question(.cupboard))
        } label: {
            Text(cupboardSummary)
                .textStyle(.showBody, color: .showRed)
        }
        .buttonStyle(.plain)
        .frame(minHeight: TouchTarget.minimum)
        .contentShape(.rect)
        .accessibilityIdentifier("home-cupboard-edit")
    }

    private var cupboardSummary: LocalizedStringResource {
        guard let options else { return .homeCupboardLabel }
        return .homeCupboardSummary(profile.cupboard(assumedUntilAnswered: options.assumedStaples).count)
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background(ColorRole.paper.color)
}
