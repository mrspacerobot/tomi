import SwiftUI

@main
struct TomiApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                // Dark palette lands with the design system; until then the light one must not meet dark system chrome.
                .preferredColorScheme(.light)
        }
    }
}
