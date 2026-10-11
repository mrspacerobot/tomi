import SwiftUI

/// Show Tomi the fridge, or change the answers.
struct HomeButtons: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(spacing: Spacing.small) {
            HomeScanButton(path: $path)
            HomeSettingsButton(path: $path)
        }
    }
}
