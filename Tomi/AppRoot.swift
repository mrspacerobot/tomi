import SwiftUI
import TomiCore

/// The first screen. Developer builds can open the voice try-out instead with the launch argument `-voice-tryout`.
struct AppRoot: View {
    let catalog: SkillCatalog?

    var body: some View {
        #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-voice-tryout") {
                VoiceTryoutView(speaker: VoiceService.speaker())
            } else {
                WelcomeView(catalog: catalog)
            }
        #else
            WelcomeView(catalog: catalog)
        #endif
    }
}
