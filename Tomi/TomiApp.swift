import SwiftUI
import TomiCore

@main
struct TomiApp: App {
    @State private var catalog = BundledLibrary.catalog()

    var body: some Scene {
        WindowGroup {
            WelcomeView(catalog: catalog)
        }
    }
}
