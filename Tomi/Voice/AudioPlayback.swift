import AVFoundation

/// Sets the phone up to play speech, so it is heard in silent mode and keeps going when other audio is playing.
enum AudioPlayback {
    static func prepare() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .spokenAudio)
        try session.setActive(true)
    }
}
