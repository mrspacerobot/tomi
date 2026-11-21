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
        .buttonStyle(ShowPrimaryButtonStyle())
        .accessibilityIdentifier("home-scan")
        Button {
            path.append(.type)
        } label: {
            Text(.homeType).textStyle(.showBody, color: .showRed)
        }
        .buttonStyle(.plain)
        .frame(minHeight: TouchTarget.minimum)
        .accessibilityIdentifier("home-type")
    }
}

#Preview {
    HomeSpecialCard(path: .constant([]), profile: CookProfile(), options: nil)
        .padding()
        .background(ColorRole.paper.color)
}
