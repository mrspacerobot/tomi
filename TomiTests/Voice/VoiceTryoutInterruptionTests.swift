import Testing

@testable import Tomi

/// Two lines asked for at once: the second stops the first, and only the second may change what the screen shows.
@MainActor
@Suite struct VoiceTryoutInterruptionTests {
    let speaker = FakeSpeaker()

    @Test func anInterruptedLineDoesNotEndTheSpeakingOfTheLineThatReplacedIt() async {
        let model = VoiceTryoutModel(speaker: speaker)
        let (first, second) = await sayTwoLinesAtOnce(with: model)
        speaker.finishOldestLine()
        await first.value
        #expect(model.isSpeaking)
        speaker.finishOldestLine()
        await second.value
        #expect(!model.isSpeaking)
    }

    @Test func anInterruptedLineThatFailsLateIsNotReportedForTheLineThatReplacedIt() async {
        let model = VoiceTryoutModel(speaker: speaker)
        let (first, second) = await sayTwoLinesAtOnce(with: model)
        speaker.failOldestLine(with: SpeakerError.unavailable)
        await first.value
        #expect(!model.didFail)
        #expect(model.isSpeaking)
        speaker.finishOldestLine()
        await second.value
        #expect(!model.didFail)
    }

    @Test func theLatestLineThatFailsIsReported() async {
        let model = VoiceTryoutModel(speaker: speaker)
        let (first, second) = await sayTwoLinesAtOnce(with: model)
        speaker.finishOldestLine()
        await first.value
        speaker.failOldestLine(with: SpeakerError.unavailable)
        await second.value
        #expect(model.didFail)
        #expect(!model.isSpeaking)
    }

    private func sayTwoLinesAtOnce(with model: VoiceTryoutModel) async -> (Task<Void, Never>, Task<Void, Never>) {
        speaker.holdsLines = true
        let first = Task { await model.say("One.") }
        let second = Task { await model.say("Two.") }
        while speaker.heldLineCount < 2 {
            await Task.yield()
        }
        return (first, second)
    }
}
