/// The speech engines the app can build, named in `voice.json`. A name that is not listed makes the file
/// unreadable, and then the system voice speaks. A new engine is a case here and a line in `VoiceService`.
nonisolated enum VoiceEngine: String, Decodable, CaseIterable {
    /// The neural voice that runs on the phone, with the system voice behind it.
    case kokoro
    /// The voices built into the phone.
    case system
}
