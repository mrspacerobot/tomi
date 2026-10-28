#if DEBUG
    import Foundation

    /// How a debug build is told to open on the voice try-out: the launch argument `-voice-tryout`, from
    /// `xcrun simctl launch` or a UI test. Add `-fake-speaker` to hear nothing and use the fake speaker.
    nonisolated enum VoiceTryoutLaunch {
        static let argument = "-voice-tryout"

        static var isRequested: Bool {
            ProcessInfo.processInfo.arguments.contains(argument)
        }
    }
#endif
