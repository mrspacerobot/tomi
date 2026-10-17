import SwiftUI

/// Opens the fridge scan.
struct HomeScanButton: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        Button {
            path.append(.scan)
        } label: {
            Text(.homeScan)
        }
        .buttonStyle(.tomiPrimary)
        .accessibilityIdentifier("home-scan")
    }
}
