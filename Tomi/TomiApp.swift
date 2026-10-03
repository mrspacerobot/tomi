import SwiftUI
import TomiCore

@main
struct TomiApp: App {
    @State private var catalog = BundledLibrary.catalog()

    var body: some Scene {
        WindowGroup {
            WelcomeView(catalog: catalog)
                // Dark palette lands with the design system; until then the light one must not meet dark system chrome.
                .preferredColorScheme(.light)
        }
    }
}
