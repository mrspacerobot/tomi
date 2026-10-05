import SwiftUI

@main
struct TomiApp: App {
    @State private var launch = AppLaunch(arguments: ProcessInfo.processInfo.arguments, now: .now)

    var body: some Scene {
        WindowGroup {
            AppRoot(
                catalog: launch.catalog,
                progress: launch.progress,
                ingredientTable: launch.ingredientTable,
                onboarding: launch.onboarding
            )
            .preferredColorScheme(launch.colorScheme)
        }
    }
}
