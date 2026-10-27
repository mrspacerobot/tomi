import SwiftUI
import TomiCore

struct HomeSpecialActions: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        Button {
            path.append(.scan)
        } label: {
            Text(.homeScan)
        }
        .buttonStyle(.tomiPrimary)
        .accessibilityIdentifier("home-scan")
        Button {
            path.append(.type)
        } label: {
            Text(.homeType)
        }
        .buttonStyle(.tomiSecondary)
        .accessibilityIdentifier("home-type")
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background(ColorRole.paper.color)
}
