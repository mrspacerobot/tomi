import SwiftUI

@main
struct TomiApp: App {
    @State private var launch = AppLaunch(arguments: ProcessInfo.processInfo.arguments, now: .now)

    var body: some Scene {
        WindowGroup {
            AppRoot(progress: launch.progress, flow: launch.flow)
        }
    }
}
