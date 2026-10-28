import AVFoundation

/// Plays speech as it is made: sentences are queued one after another and the first starts at once.
final class SpeechPlayer {
    private static let sampleRate = 24_000.0
    private let engine = AVAudioEngine()
    private let node = AVAudioPlayerNode()
    private var queued = 0
    private var epoch = 0
    private var waiting: CheckedContinuation<Void, Never>?

    /// The node is attached once for the life of the player. A stopped engine keeps its nodes, so a restart
    /// after a route change only connects and starts, and attaching again would raise an exception.
    init() {
        engine.attach(node)
    }

    /// Queues one sentence of mono samples. It plays after the sentences queued before it.
    func enqueue(_ samples: [Float]) throws {
        let format = AVAudioFormat(standardFormatWithSampleRate: Self.sampleRate, channels: 1)
        guard let format, let buffer = Self.buffer(of: samples, in: format) else {
            throw SpeakerError.unavailable
        }
        try start(with: format)
        try schedule(buffer)
    }

    private func schedule(_ buffer: AVAudioPCMBuffer) throws {
        queued += 1
        let issued = epoch
        node.scheduleBuffer(buffer, completionCallbackType: .dataPlayedBack) { _ in
            Task { @MainActor in self.played(issuedIn: issued) }
        }
        try node.playAudio()
    }

    /// Returns when everything queued has been heard, or `stop()` was called.
    func finishPlaying() async {
        guard queued > 0 else {
            return
        }
        await withCheckedContinuation { waiting = $0 }
    }

    func stop() {
        epoch += 1
        queued = 0
        node.stop()
        resumeWaiting()
    }

    private func played(issuedIn issued: Int) {
        guard issued == epoch else {
            return
        }
        queued -= 1
        if queued == 0 {
            resumeWaiting()
        }
    }

    private func resumeWaiting() {
        waiting?.resume()
        waiting = nil
    }

    private func start(with format: AVAudioFormat) throws {
        if engine.isRunning {
            return
        }
        try engine.connectNode(node, to: engine.mainMixerNode, format: format)
        try engine.start()
    }

    /// Stops the engine, so the phone can give the audio back. The next sentence starts it again.
    func shutDown() {
        stop()
        engine.stop()
    }

    private static func buffer(of samples: [Float], in format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let count = AVAudioFrameCount(samples.count)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: count) else {
            return nil
        }
        buffer.frameLength = count
        buffer.floatChannelData?[0].update(from: samples, count: samples.count)
        return buffer
    }
}
