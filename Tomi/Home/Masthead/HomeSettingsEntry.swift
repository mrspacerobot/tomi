import SwiftUI
import TomiCore

struct HomeSettingsEntry: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        Button {
            path.append(.settings)
        } label: {
            Image(systemName: "slider.horizontal.3").accessibilityLabel(Text(.homeSettings))
        }
        .buttonStyle(.plain)
        .frame(minWidth: TouchTarget.minimum, minHeight: TouchTarget.minimum)
        .contentShape(.rect)
        .accessibilityIdentifier("home-settings")
    }
}

#Preview {
    HomeMasthead(path: .constant([]), date: .now)
        .padding()
        .background(ColorRole.paper.color)
}
